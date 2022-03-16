//
//  MenuCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import Foundation
import RxSwift
import UIKit

class MenuCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then { _ in
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
    }

    private lazy var priceLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
        $0.textColor = .primary_green
    }

    public static let identyfier = "MenuCell"
    private var bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    func bind(_ viewModel: MenuCellViewModel) {
        viewModel.imageURL
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.price
            .map { "\($0)원" }
            .drive(priceLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        layer.borderColor = UIColor.gray_border.cgColor
        layer.borderWidth = 1.0
    }

    private func layout() {
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, priceLabel])
        nameStackView.axis = .vertical
        nameStackView.distribution = .fill
        nameStackView.alignment = .fill
        nameStackView.spacing = 5.0

        [
            imageView,
            nameStackView,
        ].forEach {
            addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview()
            $0.height.equalTo(112.0)
        }

        nameStackView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview().inset(9.0)
        }
    }
}
