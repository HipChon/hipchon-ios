//
//  InputCommentViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxRelay
import RxCocoa

class InputCommentViewModel {
    
    // MARK: viewModel -> view
    
    let profileImageURL: Driver<URL>
    
    
    // MARK: view -> viewModel
    
    let content = PublishRelay<String>()
    let registerButtonTapped = PublishRelay<Void>()

    init() {
        
        profileImageURL = UserModel.currentUser
            .compactMap { $0.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
    }
}
