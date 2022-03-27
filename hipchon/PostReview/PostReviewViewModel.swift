//
//  ReviewPostViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

class PostReviewViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let placeImageURL: Driver<URL>
    let placeName: Driver<String>
    let contentCount: Driver<Int>
    let photoCellVMs: Driver<[PhotoCellViewModel]>
    let photoCollectionViewHidden: Driver<Bool>
    let completeButtonValid: Driver<Bool>
    let completeButtonActivity: Driver<Bool>
    let keywordListCellVMs: Driver<[KeywordListCellViewModel]>
    let pop: Signal<Void>

    // MARK: view -> viewModel

    let selectedPhotos = BehaviorSubject<[UIImage]>(value: [])
    let content = BehaviorRelay<String>(value: "")
    let completeButtonTapped = PublishRelay<Void>()
    let selectedFirstKewords = BehaviorSubject<[KeywordModel]>(value: [])
    let selectedSecondKewords = BehaviorSubject<[KeywordModel]>(value: [])
    let selectedThirdKewords = BehaviorSubject<[KeywordModel]>(value: [])
    let canclePhotoIdx = PublishSubject<Int>()

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        let postComplete = PublishSubject<Void>()
        let activity = PublishSubject<Bool>()
        let selectedKeyword = BehaviorSubject<[KeywordModel]>(value: [])

        placeImageURL = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        contentCount = content
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)

        photoCellVMs = selectedPhotos
            .map { $0.map { PhotoCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        photoCollectionViewHidden = selectedPhotos
            .map { $0.count == 0 }
            .asDriver(onErrorJustReturn: true)

        keywordListCellVMs = Observable.just(KeywordListModel.model)
            .map { $0.map { KeywordListCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        // complete button

        completeButtonValid = Observable.combineLatest(selectedPhotos, content, selectedKeyword)
            .map { $0.0.count > 0 && $0.1.count != 0 && $0.2.count != 0 }
            .asDriver(onErrorJustReturn: false)

        completeButtonActivity = activity
            .asDriver(onErrorJustReturn: false)

        Observable.combineLatest(selectedFirstKewords, selectedSecondKewords, selectedThirdKewords)
            .map { $0 + $1 + $2 }
            .bind(to: selectedKeyword)
            .disposed(by: bag)

        completeButtonTapped
            .do(onNext: { activity.onNext(true) })
            .withLatestFrom(Observable.combineLatest(selectedPhotos, content, selectedKeyword))
            .flatMap { NetworkManager.shared.postReview(images: $0, content: $1, keywords: $2) }
            .do(onNext: { _ in activity.onNext(false) })
            .subscribe(onNext: { _ in
                postComplete.onNext(())
            })
            .disposed(by: bag)

        // cancle
        canclePhotoIdx
            .withLatestFrom(selectedPhotos) { idx, photos in
                photos.enumerated().filter { $0.0 != idx }.map { $0.element }
            }
            .bind(to: selectedPhotos)
            .disposed(by: bag)

        // scene

        pop = postComplete
            .asSignal(onErrorJustReturn: ())
    }
}
