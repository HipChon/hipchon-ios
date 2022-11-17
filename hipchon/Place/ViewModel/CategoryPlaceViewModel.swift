//
//  CategoryPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class CategoryPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let places: Driver<[BehaviorSubject<Place>]>
    let activating: Signal<Bool>
    let placeTableViewHidden: Driver<Bool>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>

    // MARK: view -> viewModel

    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedPlaceIdx = PublishRelay<Int>()

    init(_ data: Category) {
        let category = BehaviorSubject<Category>(value: data)
        let placeDatas = BehaviorSubject<[Place]>(value: [])

        places = placeDatas
            .map { $0.map { BehaviorSubject<Place>(value: $0) } }
            .asDriver(onErrorJustReturn: [])

        // 첫 로드, refresh
        Observable.merge(
            Observable.just(()),
            Singleton.shared.myPlaceRefresh
        )
        .withLatestFrom(category)
        .filter { _ in DeviceManager.shared.networkStatus }
        .flatMap { PlaceAPI.shared.getMyPlaces($0) }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { result in
            switch result {
            case let .success(data):
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
            .withLatestFrom(category)
            .flatMap { PlaceAPI.shared.getMyPlaces($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
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
            .withLatestFrom(category)
            .flatMap { PlaceAPI.shared.getMyPlaces($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
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

        pushPlaceDetailVC = selectedPlaceIdx
            .withLatestFrom(places) { $1[$0] }
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
