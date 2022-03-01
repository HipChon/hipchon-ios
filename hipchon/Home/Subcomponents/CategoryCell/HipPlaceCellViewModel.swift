//
//  HipPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipPlaceCellViewModel {
    
    // MARK: viewModel -> view

    let url: Driver<URL>
    let name: Driver<String>
    let region: Driver<String>
    let bookmarkCount: Driver<Int>
    let reviewCount: Driver<Int>

    // MARK: view -> viewModel

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        
        url = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        name = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")
        
        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")
        
        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)
        
        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)
    }
}
