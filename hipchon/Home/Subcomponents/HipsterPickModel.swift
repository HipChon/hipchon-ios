//
//  HipsterPickModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import Foundation

class HipsterPickModel: Codable {
    let id: Int?
    let region: String?
    let title: String?
    let content: String?
    let imageURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id, region, title, content, imageURL
    }
}
