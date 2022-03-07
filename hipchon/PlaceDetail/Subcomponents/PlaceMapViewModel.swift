//
//  PlaceMapViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import RxSwift
import RxCocoa
import NMapsMap

class PlaceMapViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: viewModel -> view
    
    let setAddress: Driver<String>
    let setNMGLatLng: Driver<NMGLatLng>
    
    // MARK: view -> viewModel
    
    let address = BehaviorSubject<String>(value: "")
    let nmgLatLng = BehaviorSubject<NMGLatLng>(value: NMGLatLng())
    
    init() {
        setAddress = address
            .asDriver(onErrorJustReturn: "")
        
        setNMGLatLng = nmgLatLng
            .asDriver(onErrorDriveWith: .empty())
    }
}
