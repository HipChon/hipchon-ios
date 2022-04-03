//
//  PlaceDesViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxCocoa
import RxRelay
import RxSwift

class PlaceDesViewModel {
    private let bag = DisposeBag()
    
    // MARK: viewModel -> view

    let setPlaceName: Driver<String>
    let setReviewCount: Driver<Int>
    let setBookmarkCount: Driver<Int>
    let setBookmarkYn: Driver<Bool>
    let setSector: Driver<String>
    let setBusinessHours: Driver<String>
    let setDescription: Driver<String>
    let setLink: Driver<String>
    let share: Signal<String>
    let openURL: Signal<URL>

    // MARK: view -> viewModel

    let placeName = BehaviorSubject<String>(value: "")
    let reviewCount = BehaviorSubject<Int>(value: 0)
    let bookmarkCount = BehaviorSubject<Int>(value: 0)
    let bookmarkYn = BehaviorSubject<Bool>(value: false)
    let sector = BehaviorSubject<String>(value: "")
    let businessHours = BehaviorSubject<String>(value: "")
    let description = BehaviorSubject<String>(value: "")
    let link = BehaviorSubject<String>(value: "")

    let callButtonTapped = PublishRelay<Void>()
    let shareButtonTapped = PublishRelay<Void>()
    let reviewButtonTapped = PublishRelay<Void>()
    let bookmarkButtonTapped = PublishRelay<Void>()
    let linkButtonTapped = PublishRelay<Void>()
    let reportButtonTapped = PublishRelay<Void>()
    let infoChangeButtonTapped = PublishRelay<Void>()

    init() {
        setPlaceName = placeName
            .asDriver(onErrorJustReturn: "")

        setReviewCount = reviewCount
            .asDriver(onErrorJustReturn: 0)

        setBookmarkCount = bookmarkCount
            .asDriver(onErrorJustReturn: 0)

        setBookmarkYn = bookmarkYn
            .asDriver(onErrorJustReturn: false)

        setSector = sector
            .asDriver(onErrorJustReturn: "")

        setBusinessHours = businessHours
            .asDriver(onErrorJustReturn: "")

        setDescription = description
            .asDriver(onErrorJustReturn: "")

        setLink = link
            .asDriver(onErrorJustReturn: "")
        
        share = shareButtonTapped
            .withLatestFrom(link)
            .asSignal(onErrorJustReturn: "")
        
        reportButtonTapped
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { _ in
                Singleton.shared.toastAlert.onNext("장소 신고가 완료되었습니다")
            })
            .disposed(by: bag)
        
        openURL = infoChangeButtonTapped
            .map { "http://pf.kakao.com/_xgHYNb/chat" }
            .compactMap { URL(string: $0) }
            .asSharedSequence(onErrorDriveWith: .empty())
    }
}
