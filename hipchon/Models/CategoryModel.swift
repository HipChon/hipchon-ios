//
//  CategoryModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation
import UIKit

struct CategoryModel {
    let name: String?
    let image: UIImage?

    static var tmpModels: [CategoryModel] {
        return [
            CategoryModel(name: "불멍", image: UIImage(named: "불멍") ?? UIImage()),
            CategoryModel(name: "논멍", image: UIImage(named: "논멍") ?? UIImage()),
            CategoryModel(name: "물멍", image: UIImage(named: "물멍") ?? UIImage()),
            CategoryModel(name: "밭멍", image: UIImage(named: "밭멍") ?? UIImage()),
            CategoryModel(name: "촌캉스", image: UIImage(named: "촌캉스") ?? UIImage()),
            CategoryModel(name: "체험", image: UIImage(named: "체험") ?? UIImage()),
            CategoryModel(name: "가게", image: UIImage(named: "가게") ?? UIImage()),
            CategoryModel(name: "기타", image: UIImage(named: "기타") ?? UIImage()),
        ]
    }
}
