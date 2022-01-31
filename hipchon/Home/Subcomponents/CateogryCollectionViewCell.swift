//
//  CateogryCollectionViewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    public static let identyfier = "CategoryCollectionViewCell"

    private lazy var label: UILabel = {
        let label = UILabel()

        return label
    }()

    override func layoutSubviews() {
        super.layoutSubviews()

        [
            label,
        ].forEach {
            contentView.addSubview($0)
        }

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }

        contentView.backgroundColor = .lightGray
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.layer.cornerRadius = 8.0
    }

    func setDate(_ data: CategoryModel) {
        label.text = data.name
    }
}
