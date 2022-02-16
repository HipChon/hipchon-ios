//
//  PhotoCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class PhotoCellViewModel {
    // MARK: viewModel -> view

    let url: Driver<URL>

    // MARK: view -> viewModel

    init(_ data: URL) {
        url = Driver.just(data)
    }
}
