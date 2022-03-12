//
//  ComplimentCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/09.
//

import RxSwift
import RxCocoa

class ComplimentCellViewModel {
    
    let logoImage: Driver<UIImage>
    let complimentContent: Driver<String>
    let count: Driver<Int>
    let backgroundColor: Driver<UIColor>
    
    init(_ data: ComplimentModel) {
        let compliment = BehaviorSubject<ComplimentModel>(value: data)
        
        logoImage = compliment
            .compactMap { $0.logoImage }
            .asDriver(onErrorJustReturn: UIImage())
        
        complimentContent = compliment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        count = compliment
            .compactMap { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        backgroundColor = compliment
            .compactMap { $0.backgroundColor }
            .asDriver(onErrorJustReturn: .white)
    }
}
