//
//  UserModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/14.
//

import Foundation

class UserModel: Codable {
    let id: Int?
    let name: String?
    let profileImageURL: String?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL
    }

    init(id: Int, name: String, profileImageURL: String) {
        self.id = id
        self.name = name
        self.profileImageURL = profileImageURL
    }
}
