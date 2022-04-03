//
//  ReviewDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift


class ReviewDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subviewModels

    var inputCommentVM: InputCommentViewModel?
    var reviewDetailHeaderVM: ReviewDetailHeaderViewModel?

    // MARK: viewModel -> view
    var commentVMs: [CommentCellViewModel] = []
    let reloadData: Signal<Void>


    init(_ review: BehaviorSubject<ReviewModel>) {
//        let review = BehaviorSubject<ReviewModel>(value: data)

        reviewDetailHeaderVM = ReviewDetailHeaderViewModel(review)
        inputCommentVM = InputCommentViewModel(review)
        
       

        let reload = PublishSubject<Void>()
        reloadData = reload
            .asSignal(onErrorJustReturn: ())

        Observable.merge(
            Observable.just(()),
            Singleton.shared.commentRefresh
        )
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { CommentAPI.shared.getComments($0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    self.commentVMs = data.map { CommentCellViewModel($0) }
                    reload.onNext(())
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
        
    }
}
