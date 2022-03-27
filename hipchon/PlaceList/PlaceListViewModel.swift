//
//  PlaceListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxCocoa
import RxSwift

class PlaceListViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let searchNavigationVM = SearchNavigationViewModel()

    // MARK: viewModel -> view

    let placeListCellVMs: Driver<[PlaceListCellViewModel]>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let activating: Signal<Bool>
    let placeTableViewHidden: Driver<Bool>
    let presentFilterVC: Signal<FilterViewModel>
    let presentSortVC: Signal<SortViewModel>

    // MARK: view -> viewModel

    let selectedIdx = PublishRelay<Int>()
    let changedSearchFilter = PublishSubject<SearchFilterModel>()
    let sortType = BehaviorSubject<SortType>(value: .review)
    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()

    init(_ data: SearchFilterModel) {
        let searchFilter = BehaviorSubject<SearchFilterModel>(value: data)
        let places = BehaviorSubject<[PlaceModel]>(value: [])

        // 첫 검색, sorting
        Observable.combineLatest(searchFilter, sortType)
            .flatMap { PlaceAPI.shared.getPlaceList(filter: $0, sort: $1) }
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    places.onNext(data)
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

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .do(onNext: { activatingState.onNext(true) })
            .withLatestFrom(Observable.combineLatest(searchFilter, sortType))
            .flatMap { PlaceAPI.shared.getPlaceList(filter: $0, sort: $1) }
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    places.onNext(data)
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

        // more fetching

//        moreFetching
//            .withLatestFrom(Observable.combineLatest(searchFilter, sortType))
//            .flatMap { PlaceAPI.shared.getPlaceList(filter: $0, sort: $1) }
//            .withLatestFrom(places) { $1 + $0 }
//            .bind(to: places)
//            .disposed(by: bag)

        placeTableViewHidden = places
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        placeListCellVMs = places
            .map { $0.map { PlaceListCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        searchFilter
            .compactMap { $0.filterTitle }
            .bind(to: searchNavigationVM.searchFilterTitle)
            .disposed(by: bag)

        changedSearchFilter
            .bind(to: searchFilter)
            .disposed(by: bag)

        pushPlaceDetailVC = selectedIdx
            .withLatestFrom(places) { $1[$0] }
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        presentFilterVC = searchNavigationVM
            .searchFilterButtonTapped
            .map { FilterViewModel(.research) }
            .asSignal(onErrorSignalWith: .empty())

        presentSortVC = searchNavigationVM
            .sortButtonTapped
            .withLatestFrom(sortType)
            .map { SortViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
