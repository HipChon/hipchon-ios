//
//  HashtagModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import UIKit

struct HashtagModel: Codable {
    let name: String?
    let imageURL: String?

    init(name: String) {
        self.name = name
        imageURL = nil
    }

    enum CodingKeys: String, CodingKey {
        case name, imageURL
    }

    static var tmpModels: [HashtagModel] {
        return [
            HashtagModel(name: "불멍"),
            HashtagModel(name: "논멍"),
            HashtagModel(name: "물멍"),
            HashtagModel(name: "밭멍"),
            HashtagModel(name: "촌캉스"),
            HashtagModel(name: "체험"),
            HashtagModel(name: "가게"),
            HashtagModel(name: "기타"),
        ]
    }

    var image: UIImage? {
        guard let name = name else {
            return nil
        }
        return UIImage(named: name)
    }
}
