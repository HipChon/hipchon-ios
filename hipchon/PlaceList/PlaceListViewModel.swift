//
//  PlaceListViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import Foundation
import RxCocoa

class PlaceModel: Codable {
    let name: String?
    let address: String?
    let price: Double?

    enum CodingKeys: String, CodingKey {
        case name, address, price
    }

    init(name: String, address: String, price: Double) {
        self.name = name
        self.address = address
        self.price = price
    }
}

class PlaceListViewModel {
    let places: Driver<[PlaceModel]>

    init() {
        let tmps = [
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
            PlaceModel(name: "제주도", address: "제주특별자치도 제주시 성산일출봉", price: 50000.0),
        ]

        places = Driver.just(tmps)
    }
}
