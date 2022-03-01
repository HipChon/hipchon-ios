//
//  SearchFilterButton.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation
import UIKit

class SearchFilterButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        layer.cornerRadius = 21.0
        layer.masksToBounds = true
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1.0
        setTitleColor(.black, for: .normal)
        titleLabel?.font = .GmarketSans(size: 14.0, type: .medium)
    }
}
