//
//  ReviewPlaceViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/10.
//

import RxCocoa
import RxSwift

class ReviewPlaceViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let placeName: Driver<String>
    let address: Driver<String>
    let sector: Driver<String>
    let bookmarkYn: Driver<Bool>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let share: Signal<String>

    // MARK: view -> viewModel

    let insideButtonTapped = PublishRelay<Void>()
    let bookmarkButtonTapped = PublishRelay<Void>()
    let shareButtonTapped = PublishRelay<Void>()

    init(_ place: BehaviorSubject<PlaceModel>) {
        
        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        sector = place
            .compactMap { $0.sector }
            .asDriver(onErrorJustReturn: "")

        share = shareButtonTapped
            .withLatestFrom(place)
            .compactMap { $0.link }
            .asSignal(onErrorJustReturn: "")

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: false)
        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()
        
        place
            .compactMap { $0.bookmarkYn }
            .bind(to: bookmarked)
            .disposed(by: bag)
        
        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)

        bookmarkButtonTapped
            .withLatestFrom(bookmarked)
            .subscribe(onNext: {
                switch $0 {
                case true:
                    deleteBookmark.onNext(())
                case false:
                    addBookmark.onNext(())
                }
            })
            .disposed(by: bag)

        addBookmark
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = true
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) + 1
                place.onNext($0)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.addBookmark($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)

        deleteBookmark
            .withLatestFrom(place)
            .do(onNext: {
                $0.bookmarkYn = false
                $0.bookmarkCount = ($0.bookmarkCount ?? 0) - 1
                place.onNext($0)
            })
            .withLatestFrom(place)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.deleteBookmark($0) }
            .subscribe(onNext: {
                if $0 == true {
                    // reload
                }
            })
            .disposed(by: bag)

        pushPlaceDetailVC = insideButtonTapped
            .map { PlaceDetailViewModel(place) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
