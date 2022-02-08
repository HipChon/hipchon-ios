//
//  PlaceModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

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
