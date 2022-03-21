//
//  FilterViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxCocoa
import RxRelay
import RxSwift

enum FilterSearchType {
    case search, research
}

class FilterViewModel {
    private let bag = DisposeBag()

    // MARK: subviewModels

    // MARK: viewModel -> view

    let regions: Driver<[FilterCellModel]>
    let categorys: Driver<[FilterCellModel]>
    let setRegion: Driver<FilterCellModel>
    let setCategory: Driver<FilterCellModel>
    let pushPlaceListVC: Signal<PlaceListViewModel>
    let popToSearchListVC: Signal<SearchFilterModel>

    // MARK: view -> viewModel

    let findButtonTapped = PublishRelay<Void>()
    let selectedRegion = PublishRelay<FilterCellModel>()
    let selectedCategory = PublishRelay<FilterCellModel>()
    let resetButtonTapped = PublishRelay<Void>()
    let searchButtonTapped = PublishRelay<Void>()

    init(_ befViewType: FilterSearchType) {
        regions = Driver.just(FilterCellModel.regionModels)
        categorys = Driver.just(FilterCellModel.categoryModels)

        // MARK: 지역

        let region = BehaviorSubject<FilterCellModel>(value: FilterCellModel(name: ""))

        selectedRegion
            .withLatestFrom(Observable.combineLatest(region, selectedRegion))
            .map { $0.name == $1.name ? FilterCellModel(name: "") : $1 }
            .bind(to: region)
            .disposed(by: bag)

        setRegion = region
            .asDriver(onErrorDriveWith: .empty())

        // MARK: 유형

        let category = BehaviorSubject<FilterCellModel>(value: FilterCellModel(name: ""))

        selectedCategory
            .withLatestFrom(Observable.combineLatest(category, selectedCategory))
            .map { $0.name == $1.name ? FilterCellModel(name: "") : $1 }
            .bind(to: category)
            .disposed(by: bag)

        setCategory = category
            .asDriver(onErrorDriveWith: .empty())

        // MARK: 초기화

        resetButtonTapped
            .subscribe(onNext: {
                region.onNext(FilterCellModel(name: ""))
                category.onNext(FilterCellModel(name: ""))
            })
            .disposed(by: bag)

        // MARK: 검색

        pushPlaceListVC = searchButtonTapped
            .filter { befViewType == .search }
            .withLatestFrom(Observable.combineLatest(region.asObservable(),
                                                     category.asObservable(),
                                                     resultSelector: {
                                                         SearchFilterModel(region: $0.name, category: $1.name)
                                                     }))
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        popToSearchListVC = searchButtonTapped
            .filter { befViewType == .research }
            .withLatestFrom(Observable.combineLatest(region.asObservable(),
                                                     category.asObservable(),
                                                     resultSelector: {
                                                         SearchFilterModel(region: $0.name, category: $1.name)
                                                     }))
            .asSignal(onErrorSignalWith: .empty())
    }
}
