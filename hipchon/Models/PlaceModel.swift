//
//  PlaceModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import NMapsMap

class PlaceModel: Codable {
    let id: Int?
    let name: String?
    let region: String?
    let bookmarkYn: Bool?
    let distance: Double?
    let price: Double?
    let imageURLs: [String]?
    let hashtags: [String]?
    let bookmarkCount: Int?
    let reviewCount: Int?
    
    // detail
    let sector: String?
    let businessHours: String?
    let description: String?
    let link: String?
    let geoLat: Double?
    let geoLon: Double?
    let address: String?
    let number: String?
    let reviews: [ReviewModel]?
    let compliments: [ComplimentModel]?

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
    
    var nmgLatLng: NMGLatLng? {
        guard let geoLat = geoLat,
              let geoLon = geoLon else {
            return nil
        }
        return NMGLatLng(lat: geoLat, lng: geoLon)
    }

    enum CodingKeys: String, CodingKey {
        case id, name, region, bookmarkYn, distance, price, imageURLs, hashtags, bookmarkCount, reviewCount
        case sector, businessHours, description, link, geoLat, geoLon, address, number, reviews, compliments
    }
}
