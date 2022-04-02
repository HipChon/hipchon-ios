//
//  InputCommentViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxRelay
import RxSwift

class InputCommentViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let registerButtonValid: Driver<Bool>
    let contentInit: Signal<Void>

    // MARK: view -> viewModel

    let content = BehaviorRelay<String>(value: "")
    let registerButtonTapped = PublishRelay<Void>()

    init(_ review: BehaviorSubject<ReviewModel>) {
        let postComplete = PublishSubject<Void>()
        
        profileImageURL = Singleton.shared.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        registerButtonValid = content
            .map { 0 < $0.count && $0.count <= 100 }
            .asDriver(onErrorJustReturn: true)

        registerButtonTapped
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { LoadingIndicator.showLoading() })
            .withLatestFrom(Observable.combineLatest(review.compactMap { $0.id }, content))
            .flatMap { ReviewAPI.shared.postComment(id: $0, content: $1) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    postComplete.onNext(())
                    Singleton.shared.commentRefresh.onNext(())
                    Singleton.shared.toastAlert.onNext("댓글 작성이 완료되었습니다")
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
        
        contentInit = postComplete
            .asSignal(onErrorJustReturn: ())
    }
}
