//
//  PlaceDesViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxCocoa
import RxSwift
import RxRelay

class PlaceDesViewModel {
    
    // MARK: viewModel -> view
    let setPlaceName: Driver<String>
    let setReviewCount: Driver<Int>
    let setBookmarkCount: Driver<Int>
    let setSector: Driver<String>
    let setBusinessHours: Driver<String>
    let setDescription: Driver<String>
    let setLink: Driver<String>
    
    // MARK: view -> viewModel
    let placeName = BehaviorSubject<String>(value: "")
    let reviewCount = BehaviorSubject<Int>(value: 0)
    let bookmarkCount = BehaviorSubject<Int>(value: 0)
    let sector = BehaviorSubject<String>(value: "")
    let businessHours = BehaviorSubject<String>(value: "")
    let description = BehaviorSubject<String>(value: "")
    let link = BehaviorSubject<String>(value: "")
    let linkButtonTapped = PublishRelay<Void>()
    
    init() {
        setPlaceName = placeName
            .asDriver(onErrorJustReturn: "")

        setReviewCount = reviewCount
            .asDriver(onErrorJustReturn: 0)
        
        setBookmarkCount = bookmarkCount
            .asDriver(onErrorJustReturn: 0)
        
        setSector = sector
            .asDriver(onErrorJustReturn: "")
        
        setBusinessHours = businessHours
            .asDriver(onErrorJustReturn: "")
        
        setDescription = description
            .asDriver(onErrorJustReturn: "")
        
        setLink = link
            .asDriver(onErrorJustReturn: "")
    }
}
