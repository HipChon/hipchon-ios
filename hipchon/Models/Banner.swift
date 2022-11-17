//
//  BannerModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation

struct Banner: Codable {
    let imageURL: String?
    let linkURL: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case title, linkURL
        case imageURL = "thumbnail"
    }
}
