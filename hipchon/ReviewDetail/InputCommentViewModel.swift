//
//  InputCommentViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxRelay

class InputCommentViewModel {
    
    let content = PublishRelay<String>()
    let registerButtonTapped = PublishRelay<Void>()
    
    init() {
        
    }
}
