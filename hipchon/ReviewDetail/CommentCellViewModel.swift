//
//  CommentCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxSwift
import RxCocoa
import RxRelay

class CommentCellViewModel {
    
    let profileImageURL: Driver<URL>
    let name: Driver<String>
    let content: Driver<String>
    let timeForNow: Driver<String>
    
    init(_ data: CommentModel) {
        let comment = BehaviorSubject<CommentModel>(value: data)
        
        profileImageURL = comment
            .compactMap { $0.user?.profileImageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        name = comment
            .compactMap { $0.user?.name }
            .asDriver(onErrorJustReturn: "")
        
        content = comment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        timeForNow = comment
            .compactMap { $0.dateTime }
            .asDriver(onErrorJustReturn: "")
          
    }
    
}
