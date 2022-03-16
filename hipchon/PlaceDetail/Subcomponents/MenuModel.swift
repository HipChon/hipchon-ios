//
//  MenuModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import Foundation

class MenuModel: Codable {
    let id: Int?
    let name: String?
    let price: Int?
    let imageURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, price, imageURL
    }
}
