//
//  LocalHipsterPickModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/14.
//

import Foundation

class LocalHipsterPickModel: Codable {
    let id: Int?
    let region: String?
    let title: String?
    let subTitle: String?
    let imageURL: String?
    let hipsterPicks: [HipsterPickModel]?

    enum CodingKeys: String, CodingKey {
        case id = "hipsterId"
        case title
        case region = "city"
        case subTitle = "summary"
        case imageURL = "image"
        case hipsterPicks = "postList"
    }
}
