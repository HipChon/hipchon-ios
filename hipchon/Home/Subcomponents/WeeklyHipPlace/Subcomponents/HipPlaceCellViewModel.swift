//
//  HipPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipPlaceCellViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let keywordVM: Driver<KeywordViewModel>

    // MARK: viewModel -> view

    let url: Driver<URL>
    let name: Driver<String>
    let bookmarkYn: Driver<Bool>
    let region: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    // MARK: view -> viewModel

    let bookmarkButtonTapped = PublishRelay<Void>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)

        keywordVM = place
            .compactMap { $0.keywords?.first }
            .map { KeywordViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())

        url = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        // MARK: bookmark

        let bookmarked = BehaviorSubject<Bool>(value: data.bookmarkYn ?? false)
        let bookmarkCounted = BehaviorSubject<Int>(value: data.bookmarkCount ?? 0)

        bookmarkYn = bookmarked
            .asDriver(onErrorJustReturn: false)
        
        bookmarkCount = bookmarkCounted
            .asDriver(onErrorJustReturn: 0)

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
            .withLatestFrom(bookmarkCounted)
            .do(onNext: {
                bookmarked.onNext(true)
                bookmarkCounted.onNext($0 + 1)
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
            .withLatestFrom(bookmarkCounted)
            .do(onNext: {
                bookmarked.onNext(false)
                bookmarkCounted.onNext($0 - 1)
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
    }
}
