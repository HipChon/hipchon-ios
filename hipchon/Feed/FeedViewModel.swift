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

    // MARK: viewModel -> view

    let activating: Signal<Bool>
    let reviewTableViewHidden: Driver<Bool>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
//    let presentFilterVC: Signal<FilterViewModel>
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

        reviewTableViewHidden = reviews
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        // 첫 load, sorting
        Observable.just(())
            .filter { DeviceManager.shared.networkStatus }
            .flatMap { _ in ReviewAPI.shared.getFeedReviews() }
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
            .flatMap { _ in ReviewAPI.shared.getFeedReviews() }
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
//            .flatMap { _ in ReviewAPI.shared.getFeedReviews() }
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
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
