//
//  MyCommentViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift

class MyCommentViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let activating: Signal<Bool>
    let commentTableViewHidden: Driver<Bool>
    let myCommentCellVMs: Driver<[MyCommentCellViewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()
    let reload = PublishRelay<Void>()
    let moreFetching = PublishRelay<Void>()
    let selectedCommentIdx = PublishRelay<Int>()

    init() {
        let comments = BehaviorSubject<[Comment]>(value: [])

        myCommentCellVMs = comments
            .map { $0.map { MyCommentCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        Observable.merge(
            Observable.just(()),
            Singleton.shared.myCommentRefresh
        )
        .filter { _ in DeviceManager.shared.networkStatus }
        .flatMap { _ in CommentAPI.shared.getMyComments() }
        .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { result in
            switch result {
            case let .success(data):
                comments.onNext(data)
            case let .failure(error):
                switch error.statusCode {
//                    case 401: // 401: unauthorized(토큰 만료)
//                        Singleton.shared.unauthorized.onNext(())
//                    case 404: // 404: Not Found(등록된 댓글 없음)
//                        comments.onNext([])
                case 13: // 13: Timeout
                    Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                default:
                    comments.onNext([])
                }
            }
        })
        .disposed(by: bag)

        // refresh
        let activatingState = PublishSubject<Bool>()

        activating = activatingState
            .asSignal(onErrorJustReturn: false)

        reload
            .filter { _ in DeviceManager.shared.networkStatus }
            .do(onNext: { activatingState.onNext(true) })
            .flatMap { CommentAPI.shared.getMyComments() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in activatingState.onNext(false) })
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
                    comments.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 댓글 없음)
                        comments.onNext([])
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
//            .flatMap { _ in CommentAPI.shared.getMyComments() }
//            .withLatestFrom(comments) { $1 + $0 }
//            .bind(to: comments)
//            .disposed(by: bag)

        commentTableViewHidden = comments
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: false)

        // scene

        pushReviewDetailVC = selectedCommentIdx
            .withLatestFrom(comments) { $1[$0] }
            .compactMap { $0.review }
            .map { ReviewDetailViewModel(BehaviorSubject<Review>(value: $0)) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
