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

    let inputCommentVM = InputCommentViewModel()
    var reviewDetailHeaderVM: ReviewDetailHeaderViewModel?

    // MARK: viewModel -> view
    var commentVMs: [CommentCellViewModel] = []
    let reloadData: Signal<Void>


    init(_ review: BehaviorSubject<ReviewModel>) {
//        let review = BehaviorSubject<ReviewModel>(value: data)

        reviewDetailHeaderVM = ReviewDetailHeaderViewModel(review)
            
        
       

        let reload = PublishSubject<Void>()
        reloadData = reload
            .asSignal(onErrorJustReturn: ())

        Observable.merge(
            Observable.just(()),
            Singleton.shared.myCommentRefresh
        )
            .withLatestFrom(review)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.getComments($0) }
            .subscribe(onNext: {
                self.commentVMs = $0.map { CommentCellViewModel($0) }
                reload.onNext(())
            })
            .disposed(by: bag)

        
    }
}
