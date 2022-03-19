//
//  ReviewListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class ReviewCellViewModel {
    private let bag = DisposeBag()

    // MARK: subviewModels

    let reviewPlaceVM: Driver<ReviewPlaceViewModel>

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let userName: Driver<String>
    let userReviewCount: Driver<Int>
    let postDate: Driver<String>
    let reviewImageURLs: Driver<[URL]>
    let likeYn: Driver<Bool>
    let likeCount: Driver<Int>
    let commentCount: Driver<Int>
    let content: Driver<String>

    // MARK: view -> viewModel

    let likeButtonTapped = PublishRelay<Void>()

    init(_ data: ReviewModel) {
        let review = BehaviorSubject<ReviewModel>(value: data)

        reviewPlaceVM = review
            .compactMap { $0.place }
            .map { ReviewPlaceViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

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
            .compactMap { $0.formattedPostDate }
            .asDriver(onErrorJustReturn: "")

        reviewImageURLs = review
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])

        commentCount = review
            .compactMap { $0.commentCount }
            .asDriver(onErrorJustReturn: 0)

        content = review
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        // MARK: like

        let liked = BehaviorSubject<Bool>(value: data.likeYn ?? false)
        let likeCounted = BehaviorSubject<Int>(value: data.likeCount ?? 0)
        let addLike = PublishSubject<Void>()
        let deleteLike = PublishSubject<Void>()

        likeYn = liked
            .asDriver(onErrorJustReturn: false)

        likeCount = likeCounted
            .asDriver(onErrorJustReturn: 0)

        likeButtonTapped
            .withLatestFrom(liked)
            .subscribe(onNext: {
                $0 ? deleteLike.onNext(()) : addLike.onNext(())
            })
            .disposed(by: bag)

        addLike
            .withLatestFrom(likeCounted)
            .do(onNext: {
                liked.onNext(true)
                likeCounted.onNext($0 + 1)
            })
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.addLike($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)

        deleteLike
            .withLatestFrom(likeCounted)
            .do(onNext: {
                liked.onNext(false)
                likeCounted.onNext($0 - 1)
            })
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.deleteLike($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)
    }
}
