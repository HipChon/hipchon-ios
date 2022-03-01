//
//  SearchNavigationViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/19.
//

import RxCocoa
import RxRelay
import RxSwift

class SearchNavigationViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let pop: Signal<Void>
    let setSearchFilterTitle: Driver<String>

    // MARK: view -> viewModel

    let backButtonTapped = PublishRelay<Void>()
    let searchFilterButtonTapped = PublishRelay<Void>()
    let sortButtonTapped = PublishRelay<Void>()
    let searchFilterTitle = BehaviorSubject<String>(value: "")

    init() {
        setSearchFilterTitle = searchFilterTitle
            .asDriver(onErrorJustReturn: "")

        pop = backButtonTapped
            .asSignal()
    }
}
