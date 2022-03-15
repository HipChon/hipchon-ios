//
//  SortViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/27.
//

import RxCocoa
import RxSwift

enum SortType {
    case review, bookmark, distance
}

class SortViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let curSortType: Driver<SortType>

    // MARK: view -> viewModel

    let sortType = BehaviorSubject<SortType>(value: .review)

    init(_ data: SortType) {
        sortType.onNext(data)

        curSortType = sortType
            .asDriver(onErrorJustReturn: .review)
    }
}
