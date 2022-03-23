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

    // MARK: view -> viewModel

    let content = BehaviorSubject<String>(value: "")
    let registerButtonTapped = PublishRelay<Void>()

    init() {
        profileImageURL = UserModel.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        registerButtonTapped
            .withLatestFrom(content)
            .flatMap { NetworkManager.shared.postComment(content: $0) }
            .subscribe(onNext: { _ in

            })
            .disposed(by: bag)
    }
}
