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

    let homeSearchVM = HomeSearchViewModel()
    let hipsterPickVM = HipsterPickViewModel()
    let weeklyHipPlaceVM = WeeklyHipPlaceViewModel()
    let bestReviewVM = BestReviewViewModel()
    let customerServiceVM = CustomerServiewViewModel()

    // MARK: viewModel -> view

    let cateogorys: Driver<[CategoryModel]>
    let banners: Driver<[BannerModel]>
    let pushPlaceListVC: Signal<PlaceListViewModel>
    let presentFilterVC: Signal<FilterViewModel>
    let openURL: Signal<URL>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let pushHipsterPickDetailVC: Signal<HipsterPickDetailViewModel>

    // MARK: view -> viewModel

    let selectedCategory = PublishRelay<CategoryModel>()
    let selectedBanner = PublishRelay<BannerModel>()

    init() {
        
        cateogorys = Driver.just(CategoryModel.tmpModels)

        pushPlaceListVC = selectedCategory
            .map { SearchFilterModel(personnel: 0, pet: false, region: "", category: $0.name) }
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        banners = NetworkManager.shared.getBanners()
            .asDriver(onErrorJustReturn: [])

        presentFilterVC = homeSearchVM.searchButtonTapped
            .map { FilterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
        
        openURL = selectedBanner
            .compactMap { $0.linkURL }
            .compactMap { URL(string: $0) }
            .asSignal(onErrorSignalWith: .empty())
        
        pushPlaceDetailVC = weeklyHipPlaceVM.selectedHipPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        pushHipsterPickDetailVC = hipsterPickVM.selectedHipsterPickModel
            .map { HipsterPickDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
