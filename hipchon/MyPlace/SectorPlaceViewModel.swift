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
            .flatMap { _ in NetworkManager.shared.getPlaces() }
            .bind(to: placeDatas)
            .disposed(by: bag)
        
        // refresh
        let activatingState = PublishSubject<Bool>()
        
        activating = activatingState
            .asSignal(onErrorJustReturn: false)
        
        reload
            .do(onNext: { activatingState.onNext(true) })
            .withLatestFrom(sector)
            .flatMap { _ in NetworkManager.shared.getPlaces() }
            .do(onNext: { _ in activatingState.onNext(false) })
            .bind(to: placeDatas)
            .disposed(by: bag)
                
        // more fetching
                
        moreFetching
            .flatMap { _ in NetworkManager.shared.getPlaces() }
            .withLatestFrom(placeDatas) { $1 + $0 }
            .bind(to: placeDatas)
            .disposed(by: bag)

        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
