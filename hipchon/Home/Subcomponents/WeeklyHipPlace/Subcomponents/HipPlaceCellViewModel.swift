//
//  HipPlaceCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipPlaceCellViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: subViewModels
    let firstHashtagVM = HashtagViewModel()
    let secondHashtagVM = HashtagViewModel()
    
    // MARK: viewModel -> view

    let url: Driver<URL>
    let name: Driver<String>
    let bookmarkYn: Driver<Bool>
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
        
        bookmarkYn = place
            .compactMap { $0.bookmarkYn }
            .asDriver(onErrorJustReturn: false)
        
        region = place
            .compactMap { $0.region }
            .asDriver(onErrorJustReturn: "")
        
        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 0 }
            .compactMap { $0[0] }
            .bind(to: firstHashtagVM.hashtag)
            .disposed(by: bag)
        
        place
            .compactMap { $0.hashtags }
            .filter { $0.count >= 1 }
            .compactMap { $0[1] }
            .bind(to: secondHashtagVM.hashtag)
            .disposed(by: bag)
        
        bookmarkCount = place
            .compactMap { $0.bookmarkCount }
            .asDriver(onErrorJustReturn: 0)
        
        reviewCount = place
            .compactMap { $0.reviewCount }
            .asDriver(onErrorJustReturn: 0)
    }
}
