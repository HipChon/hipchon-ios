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

    let profileImageURL: Driver<URL>
    let pushSettingVC: Signal<SettingViewModel>
    let pushEditProfileVC: Signal<EditProfileViewModel>

    // MARK: view -> viewModel

    let settingButtonTapped = PublishRelay<Void>()
    let profileImageButtonTapped = PublishRelay<Void>()

    init() {

        profileImageURL = UserModel.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())

        pushSettingVC = settingButtonTapped
            .map { SettingViewModel() }
            .asSignal(onErrorSignalWith: .empty())

        pushEditProfileVC = profileImageButtonTapped
            .map { EditProfileViewModel(nil) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
