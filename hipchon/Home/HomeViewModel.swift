//
//  HomeViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift

class HomeViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let pickViewModel = PickViewModel()
    let weeklyHipPlaceViewModel = WeeklyHipPlaceViewModel()

    // MARK: viewModel -> view

    let cateogorys: Driver<[CategoryModel]>
    let banners: Driver<[BannerModel]>
    let pushPlaceListVC: Signal<PlaceListViewModel>
    let presentFilterVC: Signal<FilterViewModel>

    // MARK: view -> viewModel

    let searchButtonTapped = PublishRelay<Void>()
    let filterButtonTapped = PublishRelay<Void>()

    init() {
        let placeListViewModel = PlaceListViewModel()

        cateogorys = Driver.just(CategoryModel.tmpModels)

        pushPlaceListVC = searchButtonTapped
            .map { _ in placeListViewModel }
            .asSignal(onErrorSignalWith: .empty())

        banners = Driver.just(BannerModel.tmpModels)

        presentFilterVC = filterButtonTapped
            .map { FilterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
