//
//  ReviewPostViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

class PostReviewViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let navigtionVM = NavigationViewModel()

    // MARK: viewModel -> view

    let placeImageURL: Driver<URL>
    let placeName: Driver<String>
    let contentCount: Driver<Int>
    let photoCellVMs: Driver<[PhotoCellViewModel]>
    let photoCollectionViewHidden: Driver<Bool>
    let pop: Signal<Void>

    // MARK: view -> viewModel

    let selectedPhotos = PublishSubject<[UIImage]>()
    let content = PublishRelay<String>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        placeImageURL = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        contentCount = content
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)

        photoCellVMs = selectedPhotos
            .map { $0.map { PhotoCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        photoCollectionViewHidden = selectedPhotos
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: true)

        pop = navigtionVM.pop
    }
}
