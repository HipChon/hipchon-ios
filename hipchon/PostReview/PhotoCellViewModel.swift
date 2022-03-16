//
//  PhotoCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa

class PhotoCellViewModel {
    // MARK: viewModel -> view

    let image: Driver<UIImage>

    // MARK: view -> viewModel

    let cancleButtonTapped = PublishRelay<Void>()

    init(_ data: UIImage) {
        image = Driver.just(data)
    }
}
