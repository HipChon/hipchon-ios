//
//  PlaceDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import NMapsMap

class PlaceDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let placeReviewListCellVMs: Driver<[PlaceReviewCellViewModel]>
    let placeDetailHeaderVM: Driver<PlaceDetailHeaderViewModel>
    let openURL: Signal<URL>
    let share: Signal<Void>
//    let pushReviewDetailVC: Signal<ReviewDetailViewModel>
    let pushPostReviewVC: Signal<PostReviewViewModel>

    // MARK: view -> viewModel
    
    let selectedReview = PublishRelay<ReviewModel>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        let reviews = BehaviorSubject<[ReviewModel]>(value: [])
        
        place
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.getReviews() }
            .asObservable()
            .bind(to: reviews)
            .disposed(by: bag)
        
        placeDetailHeaderVM = place
            .map { PlaceDetailHeaderViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())
        
        placeReviewListCellVMs = reviews
            .map { $0.map { PlaceReviewCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])
        
        
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
        
//        pushReviewDetailVC = reviewListVM.selectedReview
//            .map { ReviewDetailViewModel($0) }
//            .asSignal(onErrorSignalWith: .empty())
    }
}
