//
//  MyPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class MyPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let places: Driver<[PlaceModel]>

    // MARK: view -> viewModel

    init() {
        places = NetworkManager.shared.getPlaces()
            .asDriver(onErrorJustReturn: [])
    }
}
