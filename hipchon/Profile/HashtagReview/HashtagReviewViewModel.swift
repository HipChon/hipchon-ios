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
        Observable.merge(Observable.just(()).withLatestFrom(type),
                         Singleton.shared.myPlaceRefresh.withLatestFrom(type).filter { $0 == .myReview },
                         Singleton.shared.likedReviewRefresh.withLatestFrom(type).filter { $0 == .likeReview }
        )
            .filter { _ in DeviceManager.shared.networkStatus }
            .flatMap { ReviewAPI.shared.getMyReviews($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    reviews.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        reviews.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
        
        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { activatingState.onNext(true) })
            .withLatestFrom(type)
            .flatMap { ReviewAPI.shared.getMyReviews($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    reviews.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        reviews.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)

        // more fetching

//        moreFetching
//            .filter { DeviceManager.shared.networkStatus }
//            .flatMap { ReviewAPI.shared.getMyReviews($0) }
//            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
//            .observe(on: MainScheduler.instance)
//            .subscribe(onNext: { result in
//                switch result {
//                case .success(let data):
//                    reviews.onNext(data)
//                case let .failure(error):
//                    switch error.statusCode {
//                    case 401: // 401: unauthorized(토큰 만료)
//                        Singleton.shared.unauthorized.onNext(())
//                    case 404: // 404: Not Found(등록된 리뷰 없음)
//                        reviews.onNext([])
//                    case 13: // 13: Timeout
//                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
//                    default:
//                        Singleton.shared.unknownedError.onNext(error)
//                    }
//                }
//            })
//            .disposed(by: bag)

        reviewTableViewHidden = reviews
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        // scene

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel(BehaviorSubject<ReviewModel>(value: $0)) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
