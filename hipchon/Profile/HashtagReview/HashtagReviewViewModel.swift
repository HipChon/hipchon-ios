//
//  HashtagReviewViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift

enum ProfileReviewType {
    case myReview, likeReview
}

class HashtagReviewViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let activating: Signal<Bool>
    let reviewTableViewHidden: Driver<Bool>
    let profileReviewCellVMs: Driver<[HashtagReviewCellViewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()
    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedReviewIdx = PublishRelay<Int>()
    let deleteReviewIdx = PublishRelay<Int>()

    init(_ data: ProfileReviewType) {
        let type = BehaviorSubject<ProfileReviewType>(value: data)
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])

        profileReviewCellVMs = reviews
            .map { $0.map { HashtagReviewCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        // 첫 load, refresh
//        Observable.merge(Observable.just(()).withLatestFrom(type),
//                         Singleton.shared.myPlaceRefresh.withLatestFrom(type).filter { $0 == .myReview },
//                         Singleton.shared.likedReviewRefresh.withLatestFrom(type).filter { $0 == .likeReview }
//        )
//            .flatMap { _ in NetworkManager.shared.getReviews() }
//            .asObservable()
//            .bind(to: reviews)
//            .disposed(by: bag)

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .do(onNext: { activatingState.onNext(true) })
            .withLatestFrom(type)
            .flatMap { _ in NetworkManager.shared.getReviews() }
            .do(onNext: { _ in activatingState.onNext(false) })
            .bind(to: reviews)
            .disposed(by: bag)

        // more fetching

        moreFetching
            .flatMap { _ in NetworkManager.shared.getReviews() }
            .withLatestFrom(reviews) { $1 + $0 }
            .bind(to: reviews)
            .disposed(by: bag)

        reviewTableViewHidden = reviews
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        // scene

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
