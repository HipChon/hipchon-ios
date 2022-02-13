//
//  BannerModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation

class BannerModel {
    let imageURL: String?

    init(imageURL: String) {
        self.imageURL = imageURL
    }

    static var tmpModels: [BannerModel] {
        return [
            BannerModel(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F1?alt=media&token=b73a9623-b2be-4e2f-87bc-6b0f7b4a6a95"),
            BannerModel(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F2?alt=media&token=dd211d8a-de72-4802-80b8-83237994318a"),
            BannerModel(imageURL: "https://firebasestorage.googleapis.com:443/v0/b/ipsamitest.appspot.com/o/Post2%2Fu8Ca2VDJsBgUR3RajiIJ6uGCIUn2%2FpostImages%2F-MvLdAViV02DgAdeC02g%2Fbig%2F0?alt=media&token=26e43d26-9f5d-4aaa-9fbe-2fe11224c0c9"),
        ]
    }
}
