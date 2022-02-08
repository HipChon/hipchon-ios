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
        let tmps = [
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
        ]

        places = Driver.just(tmps)
        
        
        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel(place: $0) }
            .asSignal(onErrorSignalWith: .empty())
        
    }
}
