//
//  HashtagModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import UIKit

class Hashtag: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?

    init(id: Int, name: String) {
        self.id = id
        self.name = name
        imageURL = nil
    }

    enum CodingKeys: String, CodingKey {
        case id = "hasgtagId"
        case name
        case imageURL = "image"
    }

    static var model: [Hashtag] {
        return [
            Hashtag(id: 1, name: "불멍"),
            Hashtag(id: 2, name: "물멍"),
            Hashtag(id: 3, name: "논밭뷰"),
            Hashtag(id: 4, name: "촌캉스"),
        ]
    }

    var image: UIImage? {
        guard let name = name else {
            return nil
        }
        return UIImage(named: name)
    }
}
