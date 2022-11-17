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

    let hipPlaces: Driver<[BehaviorSubject<Place>]>

    // MARK: view -> viewModel

    let selectedIdx = PublishRelay<Int>()
    let selectedHipPlace = PublishRelay<BehaviorSubject<Place>>()

    init() {
        let hipPlaceDatas = BehaviorSubject<[Place]>(value: [])

        hipPlaces = hipPlaceDatas
            .map { $0.map { BehaviorSubject<Place>(value: $0) } }
            .asDriver(onErrorJustReturn: [])

        PlaceAPI.shared.getWeeklyHipPlace()
            .asObservable()
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
                    hipPlaceDatas.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401:
                        Singleton.shared.unauthorized.onNext(())
                    default:
                        break
                    }
                }
            })
            .disposed(by: bag)

        selectedIdx
            .withLatestFrom(hipPlaces) { $1[$0] }
            .bind(to: selectedHipPlace)
            .disposed(by: bag)
    }
}
