//
//  HashtagReviewCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift

class HashtagReviewCellViewModel {
    let imageURL: Driver<URL>
    let name: Driver<String>
    let hashtagImageURL: Driver<URL>

    init(_ data: ReviewModel) {
        let review = BehaviorSubject<ReviewModel>(value: data)

        imageURL = review
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = review
            .compactMap { $0.place?.name }
            .asDriver(onErrorDriveWith: .empty())

        hashtagImageURL = review
            .compactMap { $0.place?.hashtag?.imageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
