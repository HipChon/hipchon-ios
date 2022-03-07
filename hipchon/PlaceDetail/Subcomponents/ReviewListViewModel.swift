//
//  ReviewListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import RxCocoa
import RxSwift

class ReviewListViewModel {
    
    // MARK: viewModel -> view
    
    let reviews: Driver<[ReviewModel]>

    // MARK: view -> viewModel

    let selectedReview = PublishRelay<ReviewModel>()
    
    init() {
        reviews = NetworkManager.shared.getReviews()
            .asDriver(onErrorJustReturn: [])
    }
    
}
