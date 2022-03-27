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
            .compactMap { $0.review?.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        content = comment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        date = comment
            .compactMap { $0.formattedDate }
            .asDriver(onErrorJustReturn: "")

        deleteButtonTapped
            .withLatestFrom(comment)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.deleteComment($0) }
            .subscribe(onNext: { _ in
                Singleton.shared.toastAlert.onNext("댓글이 삭제되었습니다")
            })
            .disposed(by: bag)
    }
}
