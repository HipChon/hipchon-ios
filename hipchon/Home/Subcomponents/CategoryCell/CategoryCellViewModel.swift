//
//  CategoryCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import RxCocoa
import RxRelay

class CategoryCellViewModel {
    
    let title: Driver<String>
    
    let category = PublishRelay<CategoryModel>()
    
    init() {
        title = category
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")
    }
}
