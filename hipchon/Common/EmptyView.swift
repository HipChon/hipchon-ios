//
//  EmptyView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import Foundation
import UIKit

class EmptyView: UIView {
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "empty") ?? UIImage()
    }

    private lazy var label = UILabel().then {
        $0.text = "앗! 검색 결과가 없습니다"
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .gray04
        $0.textAlignment = .center
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            imageView,
            label,
        ].forEach {
            addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(156.0 / 723.0)
            $0.width.equalTo(imageView.snp.height).multipliedBy(134.0 / 156.0)
            $0.centerX.equalToSuperview().offset(-10.0)
            $0.centerY.equalToSuperview().multipliedBy(0.84)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
    }
}
