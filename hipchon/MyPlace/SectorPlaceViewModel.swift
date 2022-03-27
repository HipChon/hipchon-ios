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
    let activating: Signal<Bool>
    let placeTableViewHidden: Driver<Bool>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>

    // MARK: view -> viewModel

    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedPlace = PublishRelay<PlaceModel>()

    init(_ data: SectorType) {
        let sector = BehaviorSubject<SectorType>(value: data)
        let placeDatas = BehaviorSubject<[PlaceModel]>(value: [])

        places = placeDatas
            .asDriver(onErrorJustReturn: [])

        // 첫 로드, sorting
        sector
            .filter { _ in DeviceManager.shared.networkStatus }
            .flatMap { PlaceAPI.shared.getMyPlaces($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    placeDatas.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 장소 없음)
                        placeDatas.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { activatingState.onNext(true) })
            .withLatestFrom(sector)
            .flatMap { PlaceAPI.shared.getMyPlaces($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    placeDatas.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 장소 없음)
                        placeDatas.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        // more fetching

        moreFetching
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(sector)
            .flatMap { PlaceAPI.shared.getMyPlaces($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    placeDatas.onNext(data) // TODO: append
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 장소 없음)
                        placeDatas.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        placeTableViewHidden = placeDatas
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
