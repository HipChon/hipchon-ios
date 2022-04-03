//
//  CommentCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxRelay
import RxSwift

class CommentCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let profileImageURL: Driver<URL>
    let name: Driver<String>
    let content: Driver<String>
    let timeForNow: Driver<String>

    // MARK: view -> viewModel

    let reportButtonTapped = PublishRelay<Void>()

    init(_ data: CommentModel) {
        let comment = BehaviorSubject<CommentModel>(value: data)

        profileImageURL = comment
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = comment
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")

        content = comment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        timeForNow = comment
            .compactMap { $0.relatedDT }
            .asDriver(onErrorJustReturn: "")

        reportButtonTapped
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                Singleton.shared.toastAlert.onNext("댓글 신고가 완료되었습니다")
            })
            .disposed(by: bag)
    }
}
