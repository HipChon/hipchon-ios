//
//  PlaceImageCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation
import RxCocoa

class ImageCellViewModel {
    // MARK: viewModel -> view

    let url: Driver<URL>

    // MARK: view -> viewModel

    init(_ data: URL) {
        url = Driver.just(data)
    }
}
