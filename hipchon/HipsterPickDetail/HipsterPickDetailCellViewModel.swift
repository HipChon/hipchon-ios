//
//  HipsterPickDetailCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/14.
//

import RxSwift
import RxCocoa

class HipsterPickDetailCellViewModel {
    
    // MARK: subViewModels
    let reviewPlaceVM: Driver<ReviewPlaceViewModel>
    
    // MARK: viewModel -> view
    
    let imageURLs: Driver<[URL]>
    let title: Driver<String>
    let content: Driver<String>
    
    init(_ data: HipsterPickModel) {
        let hipsterPick = BehaviorSubject<HipsterPickModel>(value: data)
        
        imageURLs = hipsterPick
            .compactMap { $0.place?.imageURLs }
            .compactMap { $0.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        title = hipsterPick
            .compactMap { $0.title }
            .asDriver(onErrorJustReturn: "")
        
        content = hipsterPick
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        reviewPlaceVM = hipsterPick
            .compactMap { $0.place }
            .map { ReviewPlaceViewModel($0) }
            .asDriver(onErrorDriveWith: .empty())
        
    }
}
