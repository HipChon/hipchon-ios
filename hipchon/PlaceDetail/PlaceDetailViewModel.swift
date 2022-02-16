//
//  PlaceDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class PlaceDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let urls: Driver<[URL]>

    // MARK: view -> viewModel

    init(place: PlaceModel) {
        urls = Driver.just(place)
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
    }
}
