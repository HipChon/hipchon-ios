//
//  HipsterPickViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxRelay
import RxSwift

class HipsterPickViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let hipsterPicks: Driver<[HipsterPickModel]>

    // MARK: view -> viewModel

    init() {
        hipsterPicks = HomeNetworkManager.shared.getHipsterPick()
            .asDriver(onErrorJustReturn: [])
    }
}
