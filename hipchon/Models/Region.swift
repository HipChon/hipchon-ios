//
//  RegionModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/26.
//

import UIKit

class Region: Codable {
    let id: Int?
    let name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }

    enum CodingKeys: String, CodingKey {
        case id, name
    }

    static var model: [Region] {
        return [
            Region(id: 1, name: "제주도"),
            Region(id: 2, name: "경기도"),
            Region(id: 3, name: "대구"),
            Region(id: 4, name: "부산"),
            Region(id: 5, name: "대전"),
            Region(id: 6, name: "강원도"),
            Region(id: 7, name: "경상북도"),
            Region(id: 8, name: "충청남도"),
            Region(id: 9, name: "인천"),
            Region(id: 10, name: "광주"),
            Region(id: 11, name: "충천북도"),
            Region(id: 12, name: "경상남도"),
            Region(id: 13, name: "전라북도"),
            Region(id: 14, name: "전라남도"),
            Region(id: 15, name: "울산"),
            Region(id: 16, name: "서울"),
        ]
    }

    var image: UIImage? {
        guard let name = name else {
            return nil
        }
        return UIImage(named: name)
    }
}
