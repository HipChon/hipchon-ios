//
//  MyPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class MyPlaceCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let name: Driver<String>
    let sector: Driver<String>
    let address: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>
    let presentMemoVC: Signal<MemoViewModel>
    
    // MARK: view -> viewModel
    let memoButtonTapped = PublishRelay<Void>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        imageURL = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        sector = place
            .compactMap { $0.sector }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)
        
        presentMemoVC = memoButtonTapped
            .map { MemoViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
