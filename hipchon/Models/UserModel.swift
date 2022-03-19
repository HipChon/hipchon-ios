//
//  UserModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/14.
//

import RxSwift
import Alamofire

class UserModel: Codable {
    
    static let currentUser = BehaviorSubject<UserModel>(value: UserModel())
    
    let id: Int?
    let name: String?
    let profileImageURL: String?
    let reviewCount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImageURL, reviewCount
    }

    init(id: Int, name: String, profileImageURL: String, reviewCount: Int) {
        self.id = id
        self.name = name
        self.profileImageURL = profileImageURL
        self.reviewCount = reviewCount
    }
    
    init() {
        id = nil
        name = nil
        profileImageURL = nil
        reviewCount = nil
    }
}
