//
//  KeywordDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import RxSwift
import RxCocoa

class KeywordDetailViewModel {
    
    let iconImage: Driver<UIImage>
    let content: Driver<String>
    let count: Driver<Int>
    
    init(_ data: KeywordModel) {
        let keyword = BehaviorSubject<KeywordModel>(value: data)
        
        iconImage = keyword
            .compactMap { $0.iconImage }
            .asDriver(onErrorDriveWith: .empty())
        
        content = keyword
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        count = keyword
            .compactMap { $0.count }
            .asDriver(onErrorJustReturn: 0)
        
        
    }
}
