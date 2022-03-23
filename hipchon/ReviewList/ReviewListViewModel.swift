//
//  ReviewListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/22.
//

import RxCocoa
import RxSwift

class ReviewListViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let activating: Signal<Bool>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let reviewCellVMs: Driver<[ReviewCellViewModel]>
    let reviewCount: Driver<Int>
    let pushPostReviewVC: Signal<PostReviewViewModel>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()
    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedReviewIdx = PublishRelay<Int>()
    let postReviewButtonTapped = PublishRelay<Void>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])

        reviewCellVMs = reviews
            .map { $0.map { ReviewCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        // 첫 load, sorting
        place
            .compactMap { $0.id }
            .flatMap { _ in NetworkManager.shared.getReviews() }
            .bind(to: reviews)
            .disposed(by: bag)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .do(onNext: { activatingState.onNext(true) })
//            .withLatestFrom(Observable.combineLatest(searchFilter, sortType))
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

        // scene

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        pushPostReviewVC = postReviewButtonTapped
            .withLatestFrom(place)
            .map { PostReviewViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
