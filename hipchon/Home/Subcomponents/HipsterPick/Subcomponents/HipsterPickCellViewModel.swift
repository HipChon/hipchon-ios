//
//  HipsterPickCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipsterPickCellViewModel {
    // MARK: viewModel -> view

    let url: Driver<URL>

    // MARK: view -> viewModel

    init(_ data: BannerModel) {
        url = Driver.just(data)
            .compactMap { $0.imageURL }
            .compactMap { URL(string: $0) }
    }
}
