//
//  PlaceListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa

class PlaceListViewModel {
    // MARK: viewModel -> view

    let places: Driver<[PlaceModel]>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>

    // MARK: view -> viewModel

    let selectedPlace = PublishRelay<PlaceModel>()

    init() {
        places = NetworkManager.shared.getPlaces()
            .asDriver(onErrorJustReturn: [])

        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel(place: $0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
