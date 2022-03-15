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

    // MARK: view -> viewModel

    let insideButtonTapped = PublishRelay<Void>()
    let bookmarkButtonTapped = PublishRelay<Void>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        sector = place
            .compactMap { $0.sector }
            .asDriver(onErrorJustReturn: "")

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: data.bookmarkYn ?? false)

        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)

        let addBookmark = PublishSubject<Void>()
        let deleteBookmark = PublishSubject<Void>()

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
            .do(onNext: {
                bookmarked.onNext(true)
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
            .do(onNext: {
                bookmarked.onNext(false)
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
            .withLatestFrom(place)
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
