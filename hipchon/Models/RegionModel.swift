//
//  RegionModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/26.
//

import UIKit

class RegionModel: Codable {
    let id: Int?
    let name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name
    }

    static var model: [RegionModel] {
        return [
            RegionModel(id: 1, name: "제주"),
            RegionModel(id: 2, name: "경기"),
            RegionModel(id: 3, name: "대구"),
            RegionModel(id: 4, name: "부산"),
            RegionModel(id: 5, name: "대전"),
            RegionModel(id: 6, name: "강원"),
            RegionModel(id: 7, name: "경북"),
            RegionModel(id: 8, name: "충남"),
            RegionModel(id: 9, name: "인천"),
            RegionModel(id: 10, name: "광주"),
            RegionModel(id: 11, name: "충북"),
            RegionModel(id: 12, name: "경남"),
            RegionModel(id: 13, name: "전북"),
            RegionModel(id: 14, name: "전남"),
            RegionModel(id: 15, name: "울산"),
            RegionModel(id: 16, name: "서울"),
        ]
    }

    var image: UIImage? {
        guard let name = name else {
            return nil
        }
        return UIImage(named: name)
    }
}
