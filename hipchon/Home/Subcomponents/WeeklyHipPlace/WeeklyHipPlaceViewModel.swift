//
//  WeeklyHipPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxRelay
import RxSwift

class WeeklyHipPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let hipPlaces: Driver<[PlaceModel]>

    // MARK: view -> viewModel
    
    let selectedHipPlace = PublishRelay<PlaceModel>()

    init() {
        hipPlaces = NetworkManager.shared.getWeeklyHipPlace()
            .asDriver(onErrorJustReturn: [])
    }
}
