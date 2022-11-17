//
//  PlaceModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import Foundation

class Place: Codable {
    let id: Int?
    let name: String?
    let region: String?
    var bookmarkYn: Bool?
    let imageURLs: [String]?
    var bookmarkCount: Int?
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
    let reviews: [Review]?
    let keywords: [Keyword]?
    let menus: [Menu]?
    var memo: Memo?
    let hashtag: Hashtag?
    let topImageUrl: String?
    let topKeyword: Keyword?

    var placeTitle: String? {
        guard let region = region,
              let name = name
        else {
            return nil
        }
        return "[\(region)] \(name)"
    }

    var mtMapPoint: MTMapPoint? {
        guard let geoLat = geoLat,
              let geoLon = geoLon
        else {
            return nil
        }
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: geoLat, longitude: geoLon))
    }

    enum CodingKeys: String, CodingKey {
        case id = "placeId"
        case name
        case sector = "category"
        case address
        case region = "city"
        case imageURLs = "imageList"
        case bookmarkCount = "myplaceCnt"
        case reviewCount = "postCnt"
        case bookmarkYn = "isMyplace"
        case number = "contact"
        case businessHours = "openTime"
        case link = "homepage"
        case description = "oneLineIntro"
        case geoLat = "latitude"
        case geoLon = "longitude"
        case keywords = "keywordList"
        case reviews, memo
        case menus = "menuList"
        case hashtag = "tmp"
        case topKeyword = "keyword"
        case topImageUrl = "image"
    }

    init() {
        id = nil
        name = nil
        sector = nil
        address = nil
        region = nil
        imageURLs = nil
        bookmarkCount = nil
        reviewCount = nil
        bookmarkYn = nil
        number = nil
        businessHours = nil
        link = nil
        description = nil
        geoLat = nil
        geoLon = nil
        keywords = nil
        reviews = nil
        menus = nil
        memo = nil
        hashtag = nil
        topKeyword = nil
        topImageUrl = nil
    }
}
