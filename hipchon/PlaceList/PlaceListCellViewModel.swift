//
//  PlaceListCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import Foundation
import RxCocoa

class PlaceListCellViewModel {
    
    let name: Driver<String>
    let address: Driver<String>
    let price: Driver<String>
    
    init(_ data: PlaceModel) {
        
        name = Driver.just(data.name ?? "")
        address = Driver.just(data.address ?? "")
        price = Driver.just("\(data.price ?? 0.0)")
        
    }
    
}
