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
    let reportButtonHidden: Driver<Bool>

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
            .withLatestFrom(comment)
            .subscribe(onNext: {
                var userBlockArr = UserDefaults.standard.value(forKey: "userBlock") as? [Int] ?? []
                var commentBlockArr = UserDefaults.standard.value(forKey: "commentBlock") as? [Int] ?? []
                guard let userId = $0.user?.id,
                      let commentId = $0.id else { return }
                userBlockArr.append(userId)
                commentBlockArr.append(commentId)
                UserDefaults.standard.set(userBlockArr, forKey: "userBlock")
                UserDefaults.standard.set(commentBlockArr, forKey: "commentBlock")
                Singleton.shared.commentRefresh.onNext(())
                Singleton.shared.toastAlert.onNext("댓글 신고가 완료되었습니다")
            })
            .disposed(by: bag)
        
        reportButtonHidden = Observable.combineLatest(comment.compactMap { $0.user?.id },
                                                      Singleton.shared.currentUser.compactMap { $0.id })
            .map { $0 == $1 }
            .asDriver(onErrorJustReturn: false)
    }
}
