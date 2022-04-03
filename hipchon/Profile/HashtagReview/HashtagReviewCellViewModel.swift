//
//  HashtagReviewCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift

class HashtagReviewCellViewModel {
    private let bag = DisposeBag()

    let imageURL: Driver<URL>
    let name: Driver<String>
    let hashtagImageURL: Driver<URL>
    let deleteEnable: Driver<Bool>

    let deleteTapped = PublishSubject<Void>()
    let showTapped = PublishSubject<Void>()

    init(review: BehaviorSubject<ReviewModel>, type: BehaviorSubject<ProfileReviewType>) {
        deleteEnable = type
            .map { $0 == .myReview }
            .asDriver(onErrorJustReturn: false)

        imageURL = review
            .compactMap { $0.imageURLs?.first ?? "" }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = review
            .compactMap { $0.place?.name }
            .asDriver(onErrorDriveWith: .empty())

        hashtagImageURL = review
            .compactMap { $0.place?.hashtag?.imageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        deleteTapped
            .withLatestFrom(review)
            .map { $0.id ?? 0 }
            .flatMap { NetworkManager.shared.deleteReview($0) }
            .subscribe(onNext: { _ in
                Singleton.shared.toastAlert.onNext("리뷰가 삭제되었습니다")
            })
            .disposed(by: bag)
    }
}
