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

    let firstHashtagVM = RoundLabelViewModel()
    let secondHashtagVM = RoundLabelViewModel()

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

        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 0 }
            .compactMap { $0[0] }
            .bind(to: firstHashtagVM.content)
            .disposed(by: bag)

        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 1 }
            .compactMap { $0[1] }
            .bind(to: secondHashtagVM.content)
            .disposed(by: bag)

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

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
            .do(onNext: { bookmarked.onNext(true) })
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
            .do(onNext: { bookmarked.onNext(false) })
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
