//
//  PageBarViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/04/01.
//

import RxCocoa
import RxSwift

class PageBarViewModel {
    // MARK: viewModel -> view

    let setBar: Driver<(Double, Int)>

    // MARK: view -> viewModel

    let offsetRatio = BehaviorSubject<Double>(value: 0.0)
    let entireCount = BehaviorSubject<Int>(value: 0)

    init() {
        setBar = Observable.combineLatest(offsetRatio, entireCount)
            .filter { $0.1 != 0 }
            .asDriver(onErrorJustReturn: (0.0, 0))
    }
}
