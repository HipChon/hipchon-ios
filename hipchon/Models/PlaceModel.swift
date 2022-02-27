//
//  PlaceModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

class PlaceModel: Codable {
    let id: Int?
    let name: String?
    let region: String?
    let distance: Double?
    let price: Double?
    let imageURLs: [String]?
    let hashtags: [String]?
    let bookmarkCount: Int?
    let reviewCount: Int?

    var placeTitle: String? {
        guard let region = region,
              let name = name
        else {
            return nil
        }
        return "[\(region)] \(name)"
    }

    var priceDes: String? {
        guard let price = price else {
            return nil
        }
        return "\(Int(price))원부터"
    }

    var distanceKm: String? {
        guard let distance = distance else {
            return nil
        }
        return "\(Int(distance))Km"
    }

    enum CodingKeys: String, CodingKey {
        case id, name, region, distance, price, imageURLs, hashtags, bookmarkCount, reviewCount
    }
}
