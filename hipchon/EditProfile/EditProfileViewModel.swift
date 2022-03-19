//
//  EditProfileViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxSwift

class EditProfileViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view
    
    let profileImageURL: Driver<URL>
    let setChangedImage: Signal<UIImage>

    // MARK: view -> viewModel
    let changedImage = PublishSubject<UIImage>()

    init() {
        profileImageURL = UserModel.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        setChangedImage = changedImage
            .asSignal(onErrorSignalWith: .empty())
    }
}
