//
//  PlaceDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import NMapsMap
import RxCocoa
import RxSwift

class PlaceDetailViewModel {
    private let bag = DisposeBag()

    var headerVM: PlaceDetailHeaderViewModel?

    // MARK: subViewModels

    // MARK: viewModel -> view

    let placeDetailHeaderVM: Driver<PlaceDetailHeaderViewModel>
    let reviewCellVms: Driver<[ReviewCellViewModel]>
    let openURL: Signal<URL>
    let share: Signal<Void>
    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let pushPostReviewVC: Signal<PostReviewViewModel>

    // MARK: view -> viewModel

    let selectedReviewIdx = PublishSubject<Int>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])

        place
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.getReviews() }
            .asObservable()
            .bind(to: reviews)
            .disposed(by: bag)

        reviewCellVms = reviews
            .map { $0.map { ReviewCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        placeDetailHeaderVM = place
            .map { PlaceDetailHeaderViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        openURL = placeDetailHeaderVM
            .flatMap { $0.openURL }

        share = placeDetailHeaderVM
            .flatMap { $0.share }

        pushPostReviewVC = placeDetailHeaderVM
            .asObservable()
            .flatMap { $0.placeDesVM.reviewButtonTapped }
            .withLatestFrom(place)
            .map { PostReviewViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        pushReviewDetailVC = selectedReviewIdx
            .withLatestFrom(reviews) { $1[$0] }
            .map { ReviewDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        placeDetailHeaderVM
            .drive(onNext: { [weak self] in
                self?.headerVM = $0
            })
            .disposed(by: bag)
    }
}
