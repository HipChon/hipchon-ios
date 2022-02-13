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

    let mainFilterViewModel = MainFilterViewModel()

    // MARK: viewModel -> view

    let cateogorys: Driver<[CategoryModel]>
    let banners: Driver<[BannerModel]>
    let pushPlaceListViewController: Signal<PlaceListViewModel>

    // MARK: view -> viewModel

    init() {
        let placeListViewModel = PlaceListViewModel()

        cateogorys = Driver.just(CategoryModel.tmpModels)

        pushPlaceListViewController = mainFilterViewModel.findButtonTapped
            .map { _ in placeListViewModel }
            .asSignal(onErrorSignalWith: .empty())

        banners = Driver.just(BannerModel.tmpModels)
    }
}
