//
//  FeedViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class FeedViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let searchNavigationVM = SearchNavigationViewModel()

    // MARK: viewModel -> view

    let reviews: Driver<[ReviewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let presentFilterVC: Signal<FilterViewModel>

    // MARK: view -> viewModel

    let selectedReview = PublishRelay<ReviewModel>()

    init() {
        reviews = NetworkManager.shared.getReviews()
            .asDriver(onErrorJustReturn: [])

        pushReviewDetailVC = selectedReview
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        presentFilterVC = searchNavigationVM
            .searchFilterButtonTapped
            .map { FilterViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
