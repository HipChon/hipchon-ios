//
//  HashtagModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import UIKit

class HashtagModel: Codable {
    let id: Int?
    let name: String?
    let imageURL: String?

    init(id: Int, name: String) {
        self.id = id
        self.name = name
        imageURL = nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, imageURL
    }

    static var model: [HashtagModel] {
        return [
            HashtagModel(id: 1, name: "불멍"),
            HashtagModel(id: 2, name: "물멍"),
            HashtagModel(id: 3, name: "논밭뷰"),
            HashtagModel(id: 4, name: "촌캉스"),
        ]
    }

    var image: UIImage? {
        guard let name = name else {
            return nil
        }
        return UIImage(named: name)
    }
}
