//
//  PlaceReviewCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

class PlaceReviewCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let userName: Driver<String>
    let reviewCount: Driver<Int>
    let postDt: Driver<String>
    let reviewImageURLs: Driver<[URL]>
    let content: Driver<String>

    init(_ data: ReviewModel) {
        let review = BehaviorSubject<ReviewModel>(value: data)

        profileImageURL = review
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        userName = review
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")

        reviewCount = review
            .compactMap { $0.user?.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        postDt = review
            .compactMap { $0.formattedPostDate }
            .asDriver(onErrorJustReturn: "")

        reviewImageURLs = review
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        content = review
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
    }
}
