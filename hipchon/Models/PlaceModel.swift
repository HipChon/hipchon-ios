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
    let reviews: [ReviewModel]?
    let keywords: [KeywordModel]?
    let menus: [MenuModel]?
    let memo: MemoModel?
    let hashtag: HashtagModel?
    
    let topImageUrl: String?
    let topKeyword: KeywordModel?
    
//    // 안씀
//    let holiday: String?
//    let markerImage: String?
//    let hiple: Bool?
//    let animal: Bool?
//    let hashtag: [String]?

    var placeTitle: String? {
        guard let region = region,
              let name = name
        else {
            return nil
        }
        return "[\(region)] \(name)"
    }

    var nmgLatLng: NMGLatLng? {
        guard let geoLat = geoLat,
              let geoLon = geoLon
        else {
            return nil
        }
        return NMGLatLng(lat: geoLat, lng: geoLon)
    }

//    enum CodingKeys: String, CodingKey {
//        case id, name, region, bookmarkYn, distance, price, imageURLs, bookmarkCount, reviewCount
//        case sector, businessHours, description, link, geoLat, geoLon, address, number, reviews, keywords, menus, memo, hashtag
//    }
    
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
        case reviews, menus, memo
        case hashtag = "tmp"
        case topKeyword = "keyword"
        case topImageUrl = "placeImage"
//        case holiday, markerImage, hiple, animal, hashtag
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
