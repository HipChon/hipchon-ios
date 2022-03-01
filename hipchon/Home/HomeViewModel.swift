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

    let pickVM = PickViewModel()
    let weeklyHipPlaceVM = WeeklyHipPlaceViewModel()
    let bestReviewVM = BestReviewViewModel()

    // MARK: viewModel -> view

    let cateogorys: Driver<[CategoryModel]>
    let banners: Driver<[BannerModel]>
    let pushPlaceListVC: Signal<PlaceListViewModel>
    let presentFilterVC: Signal<FilterViewModel>

    // MARK: view -> viewModel

    let searchButtonTapped = PublishRelay<Void>()
    let selectedCategory = PublishRelay<CategoryModel>()

    init() {
        
        cateogorys = Driver.just(CategoryModel.tmpModels)

        pushPlaceListVC = selectedCategory
            .map { SearchFilterModel(personnel: 0, pet: false, region: "", category: $0.name) }
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        banners = Driver.just(BannerModel.tmpModels)

        presentFilterVC = searchButtonTapped
            .map { FilterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
        
        
    }
}
