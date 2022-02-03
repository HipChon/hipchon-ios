//
//  CategoryCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa
import RxRelay
import RxSwift

class CategoryCellViewModel {
    let title: Driver<String>

    let category = PublishRelay<CategoryModel>()

    init() {
        title = category
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")
    }
}
