//
//  BestReviewViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/27.
//

import RxCocoa
import RxRelay
import RxSwift

class BestReviewViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let reviews: Driver<[BestReviewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    let selectedBestReview = PublishRelay<BestReviewModel>()

    init() {
        reviews = NetworkManager.shared.getBestReview()
            .asDriver(onErrorJustReturn: [])

        pushReviewDetailVC = selectedBestReview
            .compactMap { $0.review }
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
