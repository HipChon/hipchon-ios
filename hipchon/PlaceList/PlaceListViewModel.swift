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
    let searchFilterTitle: Driver<String>
    let presentFilterVC: Signal<FilterViewModel>
    let presentSortVC: Signal<SortViewModel>
    let pop: Signal<Void>

    // MARK: view -> viewModel

    let selectedIdx = PublishRelay<Int>()
    let changedSearchFilter = PublishSubject<SearchFilterModel>()
    let sortType = BehaviorSubject<SortType>(value: .review)

    init(_ data: SearchFilterModel) {
        let searchFilter = BehaviorSubject<SearchFilterModel>(value: data)
        let places = BehaviorSubject<[PlaceModel]>(value: [])

        Observable.combineLatest(searchFilter, sortType)
            .withLatestFrom(NetworkManager.shared.getPlaces())
            .bind(to: places)
            .disposed(by: bag)

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

        searchFilterTitle = searchFilter
            .compactMap { ($0.personnel, $0.pet, $0.region, $0.category) }
            .map { "\($0.0) \($0.1) \($0.2) \($0.3)" }
            .asDriver(onErrorJustReturn: "")

        presentFilterVC = searchNavigationVM
            .searchFilterButtonTapped
            .map { FilterViewModel(.research) }
            .asSignal(onErrorSignalWith: .empty())

        presentSortVC = searchNavigationVM
            .sortButtonTapped
            .withLatestFrom(sortType)
            .map { SortViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        pop = searchNavigationVM.pop
    }
}
