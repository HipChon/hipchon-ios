//
//  PageCountViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

class PageCountViewModel {
    
    // MARK: viewModel -> view
    let setContent: Driver<String>
    
    // MARK: view -> viewModel
    let currentIdx = BehaviorSubject<Int>(value: 0)
    let entireIdx = BehaviorSubject<Int>(value: 0)
    
    init() {
        setContent = Observable.combineLatest(currentIdx, entireIdx)
            .map { "\($0) / \($1)" }
            .asDriver(onErrorJustReturn: "")
    }
}
