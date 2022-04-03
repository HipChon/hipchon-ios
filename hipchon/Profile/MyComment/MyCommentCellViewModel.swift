//
//  MyCommentCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift
import UIKit

class MyCommentCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let content: Driver<String>
    let date: Driver<String>

    // MARK: view -> viewModel

    let deleteButtonTapped = PublishRelay<Void>()

    init(_ data: CommentModel) {
        let comment = BehaviorSubject<CommentModel>(value: data)

        imageURL = comment
            .compactMap { $0.review?.imageURLs?.first ?? "" }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        content = comment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        date = comment
            .compactMap { $0.formattedDate }
            .asDriver(onErrorJustReturn: "")

        deleteButtonTapped
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { LoadingIndicator.showLoading() })
            .withLatestFrom(comment)
            .compactMap { $0.id }
            .flatMap { CommentAPI.shared.deleteComment(id: $0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    Singleton.shared.myCommentRefresh.onNext(())
                    Singleton.shared.toastAlert.onNext("댓글이 삭제되었습니다")
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
