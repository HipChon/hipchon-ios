//
//  PlaceModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

class PlaceModel: Codable {
    let id: Int?
    let name: String?
    let address: String?
    let category: String?
    let imageURLs: [String]?

    enum CodingKeys: String, CodingKey {
        case id, name, address, category, imageURLs
    }
}
