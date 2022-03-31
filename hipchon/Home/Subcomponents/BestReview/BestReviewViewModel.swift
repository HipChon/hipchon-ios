//
//  BestReviewViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/27.
//

import RxCocoa
import RxRelay
import RxSwift

class BestReviewViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let reviews: Driver<[BestReviewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    let selectedBestReview = PublishRelay<BestReviewModel>()

    init() {
        let reviewDatas = BehaviorSubject<[BestReviewModel]>(value: [])
        
        reviews = reviewDatas
            .asDriver(onErrorJustReturn: [])

        Observable.just(())
            .filter { DeviceManager.shared.networkStatus }
            .flatMap { _ in ReviewAPI.shared.getBestReview() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    reviewDatas.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        reviewDatas.onNext([])
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
        
        pushReviewDetailVC = selectedBestReview
            .compactMap { $0.review }
            .map { ReviewDetailViewModel(BehaviorSubject<ReviewModel>(value: $0)) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
