//
//  FilterCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import RxCocoa
import RxSwift

class FilterCellViewModel {
    // MARK: viewModel -> view

    let name: Driver<String>

    // MARK: view -> viewModel

    init(_ data: FilterModel) {
        name = Driver.just(data)
            .compactMap { $0.name }
    }
}
