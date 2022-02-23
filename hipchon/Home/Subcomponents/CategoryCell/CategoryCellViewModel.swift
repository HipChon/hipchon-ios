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
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let title: Driver<String>
    let image: Driver<UIImage>

    // MARK: view -> viewModel

    let category = PublishRelay<CategoryModel>()

    init() {
        title = category
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        image = category
            .compactMap { $0.image }
            .asDriver(onErrorJustReturn: UIImage())
    }
}
