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

    // MARK: view -> viewModel

    init() {
        reviews = NetworkManager.shared.getBestReview()
            .asDriver(onErrorJustReturn: [])
    }
}
