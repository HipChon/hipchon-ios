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
            .flatMap { ReviewAPI.shared.getBestReview() }
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    reviewDatas.onNext(data)
                case .failure(let error):
                    switch error.statusCode {
                    case 401:
                        Singleton.shared.unauthorized.onNext(())
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
