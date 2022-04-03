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
            .map { $0.map { ReviewCellViewModel(BehaviorSubject<ReviewModel>(value: $0)) } }
            .asDriver(onErrorJustReturn: [])

        // 첫 load, sorting
        place
            .compactMap { $0.id }
            .filter { _ in DeviceManager.shared.networkStatus }
            .flatMap { ReviewAPI.shared.getPlaceReview($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
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

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .withLatestFrom(place)
            .compactMap { $0.id }
            .filter { _ in DeviceManager.shared.networkStatus }
            .do(onNext: { _ in activatingState.onNext(true) })
            .flatMap { ReviewAPI.shared.getPlaceReview($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
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
//            .withLatestFrom(place)
//            .compactMap { $0.id }
//            .filter { DeviceManager.shared.networkStatus }
//            .flatMap { ReviewAPI.shared.getPlaceReview($0) }
//            .withLatestFrom(reviews) { $1 + $0 }
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

        // scene

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel(BehaviorSubject<ReviewModel>(value: $0)) }
            .asSignal(onErrorSignalWith: .empty())

        pushPostReviewVC = postReviewButtonTapped
            .withLatestFrom(place)
            .map { PostReviewViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
