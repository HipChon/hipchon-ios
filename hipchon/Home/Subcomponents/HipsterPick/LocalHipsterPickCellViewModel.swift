//
//  HipsterPickCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class LocalHipsterPickCellViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let regionLabelVM = RoundLabelViewModel()

    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let title: Driver<String>
    let subTitle: Driver<String>

    // MARK: view -> viewModel

    init(_ data: LocalHipsterPickModel) {
        let localHipsterPick = BehaviorSubject<LocalHipsterPickModel>(value: data)

        imageURL = localHipsterPick
            .compactMap { $0.imageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        localHipsterPick
            .compactMap { $0.region }
            .bind(to: regionLabelVM.content)
            .disposed(by: bag)

        title = localHipsterPick
            .compactMap { $0.title }
            .asDriver(onErrorJustReturn: "")

        subTitle = localHipsterPick
            .compactMap { $0.subTitle }
            .asDriver(onErrorJustReturn: "")
    }
}
