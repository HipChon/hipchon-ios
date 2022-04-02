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

    let hipPlaces: Driver<[BehaviorSubject<PlaceModel>]>

    // MARK: view -> viewModel

    let selectedIdx = PublishRelay<Int>()
    let selectedHipPlace = PublishRelay<BehaviorSubject<PlaceModel>>()

    init() {
        let hipPlaceDatas = BehaviorSubject<[PlaceModel]>(value: [])

        hipPlaces = hipPlaceDatas
            .map { $0.map { BehaviorSubject<PlaceModel>(value: $0) } }
            .asDriver(onErrorJustReturn: [])

        PlaceAPI.shared.getWeeklyHipPlace()
            .asObservable()
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    hipPlaceDatas.onNext(data)
                case .failure(let error):
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
