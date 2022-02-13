//
//  ProfileViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import RxCocoa
import RxSwift

class ProfileViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view

    let pushSettingVC: Signal<SettingViewModel>

    // MARK: view -> viewModel

    let settingButtonTapped = PublishRelay<Void>()

    init() {
        pushSettingVC = settingButtonTapped
            .map { SettingViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
