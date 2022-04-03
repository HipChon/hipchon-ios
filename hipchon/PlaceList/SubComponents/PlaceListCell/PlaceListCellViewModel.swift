//
//  PlaceListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa
import RxSwift

class PlaceListCellViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let pageCountVM = PageCountViewModel()
    let keywordVM: Driver<KeywordViewModel>

    // MARK: viewModel -> view

    let placeImageURLs: Driver<[URL]>
    let name: Driver<String>
    let region: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    // MARK: view -> viewModel

    let currentIdx = BehaviorRelay<Int>(value: 1)

    init(_ place: BehaviorSubject<PlaceModel>) {
        keywordVM = place
            .compactMap { $0.keywords?.first }
            .map { KeywordViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        placeImageURLs = place
            .compactMap { $0.imageURLs }
            .map { $0.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        place
            .compactMap { $0.imageURLs?.count }
            .bind(to: pageCountVM.entireIdx)
            .disposed(by: bag)

        currentIdx
            .map { $0 + 1 }
            .bind(to: pageCountVM.currentIdx)
            .disposed(by: bag)
    }
}
