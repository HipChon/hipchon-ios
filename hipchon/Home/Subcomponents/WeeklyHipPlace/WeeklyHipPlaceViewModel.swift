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
    
    let hipPlacesCellVMs: Driver<[HipPlaceCellViewModel]>

    // MARK: view -> viewModel

    let selectedIdx = PublishRelay<Int>()
    let selectedHipPlace = PublishRelay<PlaceModel>()

    init() {
        let hipPlaces = BehaviorSubject<[PlaceModel]>(value: [])

        hipPlacesCellVMs = hipPlaces
            .map { $0.map { HipPlaceCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        NetworkManager.shared.getWeeklyHipPlace()
            .asObservable()
            .subscribe(onNext: {
                hipPlaces.onNext($0)
            })
            .disposed(by: bag)

        selectedIdx
            .withLatestFrom(hipPlaces) { $1[$0] }
            .bind(to: selectedHipPlace)
            .disposed(by: bag)
    }
}
