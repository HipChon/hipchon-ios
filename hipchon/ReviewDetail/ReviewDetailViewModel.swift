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

    // MARK: subviewModels
    let reviewPlaceVM: Driver<ReviewPlaceViewModel>
    
    // MARK: viewModel -> view

    let placeName: Driver<String>
    let profileImageURL: Driver<URL>
    let userName: Driver<String>
    let userReviewCount: Driver<Int>
    let postDate: Driver<String>
    let reviewImageURLs: Driver<[URL]>
    let likeCount: Driver<Int>
    let commentCount: Driver<Int>
    let content: Driver<String>

    // MARK: view -> viewModel

    init(_ data: ReviewModel) {
        let review = BehaviorSubject<ReviewModel>(value: data)
        
        reviewPlaceVM = review
            .compactMap { $0.place }
            .map { ReviewPlaceViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())
        
        placeName = review
            .compactMap { $0.place?.name }
            .asDriver(onErrorJustReturn: "")

        profileImageURL = review
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        userName = review
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")
        
        userReviewCount = review
            .compactMap { $0.user?.reviewCount }
            .asDriver(onErrorJustReturn: 0)
        
        postDate = review
            .compactMap { $0.postDt }
            .asDriver(onErrorJustReturn: "")

        reviewImageURLs = review
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        likeCount = review
            .compactMap { $0.likeCount }
            .asDriver(onErrorJustReturn: 0)
        
        commentCount = review
            .compactMap { $0.commentCount }
            .asDriver(onErrorJustReturn: 0)

        content = review
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
    }
}
