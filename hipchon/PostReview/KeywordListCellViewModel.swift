//
//  KeywordListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/12.
//

import RxCocoa
import RxSwift

class KeywordListCellViewModel {
    private let bag = DisposeBag()

    let title: Driver<String>

    let firstKeyword: Driver<KeywordModel>
    let secondKeyword: Driver<KeywordModel>
    let thirdKeyword: Driver<KeywordModel>
    let fourthKeyword: Driver<KeywordModel>
    let fifthKeyword: Driver<KeywordModel>

    let firstKeywordButtonColor: Driver<UIColor>
    let secondKeywordButtonColor: Driver<UIColor>
    let thirdKeywordButtonColor: Driver<UIColor>
    let fourthKeywordButtonColor: Driver<UIColor>
    let fifthKeywordButtonColor: Driver<UIColor>

    let firstKeywordButtonTapped = PublishRelay<Void>()
    let secondKeywordButtonTapped = PublishRelay<Void>()
    let thirdKeywordButtonTapped = PublishRelay<Void>()
    let fourthKeywordButtonTapped = PublishRelay<Void>()
    let fifthKeywordButtonTapped = PublishRelay<Void>()

    let selectedKeywords = BehaviorSubject<[KeywordModel]>(value: [])

    init(_ data: KeywordListModel) {
        let keywordList = BehaviorSubject<KeywordListModel>(value: data)
        let addIdxKeyword = PublishSubject<Int>()
        let removeIdxKeyword = PublishSubject<Int>()

        title = keywordList
            .compactMap { $0.title }
            .asDriver(onErrorJustReturn: "")

        addIdxKeyword
            .withLatestFrom(keywordList) { $1.keywords?[$0] }
            .compactMap { $0 }
            .withLatestFrom(selectedKeywords) { $1 + [$0] }
            .bind(to: selectedKeywords)
            .disposed(by: bag)

        removeIdxKeyword
            .withLatestFrom(keywordList) { $1.keywords?[$0] }
            .compactMap { $0 }
            .withLatestFrom(selectedKeywords) { new, orgs in
                orgs.filter { $0.content != new.content }
            }
            .bind(to: selectedKeywords)
            .disposed(by: bag)

        // first

        firstKeyword = keywordList
            .compactMap { $0.keywords }
            .map { $0[0] }
            .asDriver(onErrorDriveWith: .empty())

        let firstSelected = BehaviorSubject<Bool>(value: false)

        firstKeywordButtonTapped
            .withLatestFrom(firstSelected)
            .map { !$0 }
            .bind(to: firstSelected)
            .disposed(by: bag)

        firstKeywordButtonColor = firstSelected
            .withLatestFrom(keywordList) {
                $0 ? ($1.selectedColor ?? .white) : .white
            }
            .asDriver(onErrorJustReturn: .white)

        firstSelected
            .subscribe(onNext: {
                $0 ? addIdxKeyword.onNext(0) : removeIdxKeyword.onNext(0)
            })
            .disposed(by: bag)

        // second

        secondKeyword = keywordList
            .compactMap { $0.keywords }
            .map { $0[1] }
            .asDriver(onErrorDriveWith: .empty())

        let secondSelected = BehaviorSubject<Bool>(value: false)

        secondKeywordButtonTapped
            .withLatestFrom(secondSelected)
            .map { !$0 }
            .bind(to: secondSelected)
            .disposed(by: bag)

        secondKeywordButtonColor = secondSelected
            .withLatestFrom(keywordList) {
                $0 ? ($1.selectedColor ?? .white) : .white
            }
            .asDriver(onErrorJustReturn: .white)

        secondSelected
            .subscribe(onNext: {
                $0 ? addIdxKeyword.onNext(1) : removeIdxKeyword.onNext(1)
            })
            .disposed(by: bag)

        // third

        thirdKeyword = keywordList
            .compactMap { $0.keywords }
            .map { $0[2] }
            .asDriver(onErrorDriveWith: .empty())

        let thirdSelected = BehaviorSubject<Bool>(value: false)

        thirdKeywordButtonTapped
            .withLatestFrom(thirdSelected)
            .map { !$0 }
            .bind(to: thirdSelected)
            .disposed(by: bag)

        thirdKeywordButtonColor = thirdSelected
            .withLatestFrom(keywordList) {
                $0 ? ($1.selectedColor ?? .white) : .white
            }
            .asDriver(onErrorJustReturn: .white)

        thirdSelected
            .subscribe(onNext: {
                $0 ? addIdxKeyword.onNext(2) : removeIdxKeyword.onNext(2)
            })
            .disposed(by: bag)

        // fourth

        fourthKeyword = keywordList
            .compactMap { $0.keywords }
            .map { $0[3] }
            .asDriver(onErrorDriveWith: .empty())

        let fourthSelected = BehaviorSubject<Bool>(value: false)

        fourthKeywordButtonTapped
            .withLatestFrom(fourthSelected)
            .map { !$0 }
            .bind(to: fourthSelected)
            .disposed(by: bag)

        fourthKeywordButtonColor = fourthSelected
            .withLatestFrom(keywordList) {
                $0 ? ($1.selectedColor ?? .white) : .white
            }
            .asDriver(onErrorJustReturn: .white)

        fourthSelected
            .subscribe(onNext: {
                $0 ? addIdxKeyword.onNext(3) : removeIdxKeyword.onNext(3)
            })
            .disposed(by: bag)

        // fifth

        fifthKeyword = keywordList
            .compactMap { $0.keywords }
            .map { $0[4] }
            .asDriver(onErrorDriveWith: .empty())

        let fifthSelected = BehaviorSubject<Bool>(value: false)

        fifthKeywordButtonTapped
            .withLatestFrom(fifthSelected)
            .map { !$0 }
            .bind(to: fifthSelected)
            .disposed(by: bag)

        fifthKeywordButtonColor = fifthSelected
            .withLatestFrom(keywordList) {
                $0 ? ($1.selectedColor ?? .white) : .white
            }
            .asDriver(onErrorJustReturn: .white)

        fifthSelected
            .subscribe(onNext: {
                $0 ? addIdxKeyword.onNext(4) : removeIdxKeyword.onNext(4)
            })
            .disposed(by: bag)
    }
}
