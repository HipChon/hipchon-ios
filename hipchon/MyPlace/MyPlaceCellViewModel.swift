//
//  MyPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift
import UIKit

class MyPlaceCellViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let name: Driver<String>
    let sector: Driver<String>
    let address: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>
    let memoContent: Driver<String>
    let memoColor: Driver<UIColor>
    let presentMemoVC: Signal<MemoViewModel>

    // MARK: view -> viewModel

    let memoButtonTapped = PublishRelay<Void>()
    let memoChanged = PublishSubject<Void>()

    init(_ place: BehaviorSubject<PlaceModel>) {
        imageURL = place
            .compactMap { $0.topImageUrl }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")

        sector = place
            .compactMap { $0.sector }
            .asDriver(onErrorJustReturn: "")

        address = place
            .compactMap { $0.address }
            .asDriver(onErrorJustReturn: "")

        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)

        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)

        memoContent = place
            .compactMap { $0.memo?.content }
            .asDriver(onErrorJustReturn: "")

        memoColor = place
            .compactMap { $0.memo?.backgroundColor }
            .asDriver(onErrorJustReturn: .gray05)

        // TODO: remove
        place
            .filter { $0.memo == nil && $0.id != nil }
            .map { org -> PlaceModel in
                let content = UserDefaults.standard.value(forKey: "\(org.id ?? -1)Content") as? String
                let color = UserDefaults.standard.value(forKey: "\(org.id ?? -1)Color") as? String
                org.memo = MemoModel(content: content, color: color)
                return org
            }
            .bind(to: place)
            .disposed(by: bag)


        presentMemoVC = memoButtonTapped
            .map { MemoViewModel(place) }
            .asSignal(onErrorSignalWith: .empty())
    }
}

extension String {
    func stringToMemoColor() -> UIColor {
        switch self {
        case "primary_green":
            return .primary_green
        case "secondary_yellow":
            return .secondary_yellow
        case "secondary_blue":
            return .secondary_blue
        case "secondary_purple":
            return .secondary_purple
        default:
            return .gray04
        }
    }
}
