//
//  PlaceMapViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import RxSwift
import RxCocoa

class PlaceMapViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: viewModel -> view
    
    let setAddress: Driver<String>
    
    // MARK: view -> viewModel
    
    let address = BehaviorSubject<String>(value: "")
    
    init() {
        setAddress = address
            .asDriver(onErrorJustReturn: "")
    }
}
