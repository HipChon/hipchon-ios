//
//  ReviewComplimentListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import RxCocoa
import RxSwift

class ReviewComplimentListViewModel {
    
    // MARK: viewModel -> view
    
    let complimentCellVMs: Driver<[ComplimentCellViewModel]>

    // MARK: view -> viewModel

    init(_ data: [ComplimentModel]) {
        let compliments = BehaviorSubject<[ComplimentModel]>(value: data)
        
        complimentCellVMs = compliments
            .map { $0.map { ComplimentCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])
    }
    
}
