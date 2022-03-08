//
//  RoundLabelViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import RxCocoa
import RxSwift

class RoundLabelViewModel {
    
    // MARK: viewModel -> view
    let setContent: Driver<String>
    
    // MARK: view -> viewModel
    let content = BehaviorSubject<String>(value: "")
    
    init() {
        setContent = content
            .asDriver(onErrorJustReturn: "")
    }
}
