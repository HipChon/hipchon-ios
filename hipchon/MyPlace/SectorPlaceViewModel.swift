//
//  MyPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

enum SectorType: String {
    case entire = "전체"
    case cafe = "카페"
    case food = "미식"
    case activity = "활동"
    case natural = "자연"
}

class SectorPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let places: Driver<[PlaceModel]>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>

    // MARK: view -> viewModel

    let selectedPlace = PublishRelay<PlaceModel>()

    init(_ data: SectorType) {
        places = NetworkManager.shared.getPlaces() // TODO: sectorType
            .asDriver(onErrorJustReturn: [])

        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
