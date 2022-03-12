//
//  ReviewPostViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxSwift
import RxCocoa

class PostReviewViewModel {
    
    let navigtionVM = NavigationViewModel()
    
    let placeImageURL: Driver<URL>
    let placeName: Driver<String>
    
    let pop: Signal<Void>
    
    init(_ data: PlaceModel) {
        
        let place = BehaviorSubject<PlaceModel>(value: data)
        
        placeImageURL = place
            .compactMap { $0.imageURLs?.first }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        placeName = place
            .compactMap { $0.name }
            .asDriver(onErrorJustReturn: "")
        
        
        pop = navigtionVM.pop
    }
    
}
