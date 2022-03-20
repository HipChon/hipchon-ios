//
//  MyCommentCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift
import UIKit

class MyCommentCellViewModel {
    
    // MARK: viewModel -> view
    
    let imageURL: Driver<URL>
    let content: Driver<String>
    let date: Driver<String>

    init(_ data: CommentModel) {
        let comment = BehaviorSubject<CommentModel>(value: data)
        
        imageURL = comment
            .compactMap { $0.review?.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        content = comment
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        date = comment
            .compactMap { $0.formattedDate }
            .asDriver(onErrorJustReturn: "")

    }
}
