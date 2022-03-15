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
    let localHipsterPickVM = LocalHipsterPickViewModel()
    let weeklyHipPlaceVM = WeeklyHipPlaceViewModel()
    let bannerPageCountVM = PageCountViewModel()
    let bestReviewVM = BestReviewViewModel()
    let customerServiceVM = CustomerServiceViewModel()

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
    let bannerCurrentIdx = BehaviorRelay<Int>(value: 1)

    init() {
        
        cateogorys = Driver.just(CategoryModel.tmpModels)

        pushPlaceListVC = selectedCategory
            .map { SearchFilterModel(personnel: 0, pet: false, region: "", category: $0.name) }
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        banners = NetworkManager.shared.getBanners()
            .asDriver(onErrorJustReturn: [])
        
        banners
            .map { $0.count }
            .asObservable()
            .bind(to: bannerPageCountVM.entireIdx)
            .disposed(by: bag)
        
        bannerCurrentIdx
            .map { $0 + 1 }
            .bind(to: bannerPageCountVM.currentIdx)
            .disposed(by: bag)
        
        // MARK: scene

        presentFilterVC = homeSearchVM.searchButtonTapped
            .map { FilterViewModel(.search) }
            .asSignal(onErrorSignalWith: .empty())
        
        openURL = Observable.merge(
            selectedBanner.compactMap { $0.linkURL },
            customerServiceVM.selectedURLStr
        )
            .compactMap { URL(string: $0) }
            .asSignal(onErrorSignalWith: .empty())
        
        pushPlaceDetailVC = weeklyHipPlaceVM.selectedHipPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        pushHipsterPickDetailVC = localHipsterPickVM.selectedLocalHipsterPick
            .map { HipsterPickDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
