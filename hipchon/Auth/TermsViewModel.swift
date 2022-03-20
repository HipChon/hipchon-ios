//
//  TermsViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/21.
//

import RxCocoa
import RxRelay

class TermsViewModel {
    
    // MARK: viewModel -> view
    
    let pushEditProfileVC: Signal<EditProfileViewModel>
    
    // MARK: view -> viewModel
    
    let completeButtonTapped = PublishRelay<Void>()
    
    init() {
        pushEditProfileVC = completeButtonTapped
            .map { EditProfileViewModel() }
            .asSignal(onErrorSignalWith: .empty())
    }
}
