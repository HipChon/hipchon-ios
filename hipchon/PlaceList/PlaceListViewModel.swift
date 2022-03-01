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

    let places: Driver<[PlaceModel]>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let searchFilterTitle: Driver<String>
    let presentFilterVC: Signal<FilterViewModel>
    let presentSortVC: Signal<SortViewModel>
    let pop: Signal<Void>

    // MARK: view -> viewModel

    let selectedPlace = PublishRelay<PlaceModel>()

    init(_ data: SearchFilterModel) {
        let searchFilter = BehaviorSubject<SearchFilterModel>(value: data)

        places = NetworkManager.shared.getPlaces()
            .asDriver(onErrorJustReturn: [])

        searchFilter
            .compactMap { $0.filterTitle }
            .bind(to: searchNavigationVM.searchFilterTitle)
            .disposed(by: bag)

        pushPlaceDetailVC = selectedPlace
            .map { PlaceDetailViewModel(place: $0) }
            .asSignal(onErrorSignalWith: .empty())

        searchFilterTitle = searchFilter
            .compactMap { ($0.personnel, $0.pet, $0.region, $0.category) }
            .map { "\($0.0) \($0.1) \($0.2) \($0.3)" }
            .asDriver(onErrorJustReturn: "")

        presentFilterVC = searchNavigationVM
            .searchFilterButtonTapped
            .map { FilterViewModel() }
            .asSignal(onErrorSignalWith: .empty())

        presentSortVC = searchNavigationVM
            .sortButtonTapped
            .map { SortViewModel() }
            .asSignal(onErrorSignalWith: .empty())

        pop = searchNavigationVM.pop
    }
}
