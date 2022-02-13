//
//  FeedViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class FeedViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let reviews: Driver<[ReviewModel]>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>

    // MARK: view -> viewModel

    let selectedReview = PublishRelay<ReviewModel>()

    init() {
        let tmps = [
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
            ReviewModel(title: "완전 좋은 여행이었어요", content: "시설이 좋아서 너무 잘 다녀왔네요", place: "제주도 숙소"),
        ]

        reviews = Driver.just(tmps)

        pushReviewDetailVC = selectedReview
            .map { ReviewDetailViewModel(review: $0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
