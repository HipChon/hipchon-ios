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

    init() {
        let postComplete = PublishSubject<Void>()
        
        profileImageURL = Singleton.shared.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        registerButtonValid = content
            .map { 0 < $0.count && $0.count <= 100 }
            .asDriver(onErrorJustReturn: true)

        registerButtonTapped
            .withLatestFrom(content)
            .flatMap { NetworkManager.shared.postComment(content: $0) }
            .subscribe(onNext: { _ in
                // success
                postComplete.onNext(())
                Singleton.shared.toastAlert.onNext("댓글 작성이 완료되었습니다")
            })
            .disposed(by: bag)
        
        contentInit = postComplete
            .asSignal(onErrorJustReturn: ())
    }
}
