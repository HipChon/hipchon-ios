//
//  FeedViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class FeedViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let searchNavigationVM = SearchNavigationViewModel()

    // MARK: viewModel -> view

    let activating: Signal<Bool>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let presentFilterVC: Signal<FilterViewModel>
//    let pushPlaceDetailVC: Signal<ReviewPlaceViewModel>

    let reviewCellVMs: Driver<[ReviewCellViewModel]>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()
    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedReviewIdx = PublishRelay<Int>()

    init() {
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])

        reviewCellVMs = reviews
            .map { $0.map { ReviewCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        // 첫 load, sorting
        viewAppear
            .flatMap { NetworkManager.shared.getReviews() }
            .asObservable()
            .bind(to: reviews)
            .disposed(by: bag)
        
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

        presentFilterVC = searchNavigationVM
            .searchFilterButtonTapped
            .map { FilterViewModel(.search) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
