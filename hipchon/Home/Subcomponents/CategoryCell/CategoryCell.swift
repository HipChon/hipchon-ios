//
//  CategoryCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxSwift
import UIKit

class CategoryCell: UICollectionViewCell {
    public static let identyfier = "CategoryCell"
    private let bag = DisposeBag()

    private lazy var label: UILabel = {
        let label = UILabel()

        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: CategoryCellViewModel) {
        viewModel.title
            .drive(label.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.backgroundColor = .lightGray
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.layer.cornerRadius = 8.0
    }

    private func layout() {
        [
            label,
        ].forEach {
            contentView.addSubview($0)
        }

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func setDate(_ data: CategoryModel) {
        label.text = data.name
    }
}
