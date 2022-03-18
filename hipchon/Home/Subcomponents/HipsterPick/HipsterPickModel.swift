//
//  HipsterPickModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import Foundation

class HipsterPickModel: Codable {
    let id: Int?
    let title: String?
    let content: String?
    let place: PlaceModel?
    let bookmarkYn: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, content, place, bookmarkYn
    }
}
