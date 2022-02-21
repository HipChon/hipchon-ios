//
//  ReviewDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class ReviewDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let userName: Driver<String>
    let placeName: Driver<String>
    let reviewImageURL: Driver<URL>
    let content: Driver<String>

    // MARK: view -> viewModel

    init(_ data: ReviewModel) {
        let review = BehaviorSubject<ReviewModel>(value: data)
        
        profileImageURL = review
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        userName = review
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")

        placeName = review
            .compactMap { $0.place?.name }
            .asDriver(onErrorJustReturn: "")

        reviewImageURL = review
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        content = review
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
    }
}
