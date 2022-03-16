//
//  LocalHipsterPickViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxRelay
import RxSwift

class LocalHipsterPickViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let localHipsterPicks: Driver<[LocalHipsterPickModel]>

    // MARK: view -> viewModel

    let selectedLocalHipsterPick = PublishRelay<LocalHipsterPickModel>()

    init() {
        localHipsterPicks = NetworkManager.shared.getLocalHipsterPicks()
            .asDriver(onErrorJustReturn: [])
    }
}
