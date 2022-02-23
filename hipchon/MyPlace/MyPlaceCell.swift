//
//  MyPlaceCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxSwift
import UIKit

class MyPlaceCell: UITableViewCell {
    private lazy var placeImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    }

    private lazy var categoryLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .lightGray
    }

    public static let identyfier = "ReviewListCell"
    private let bag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: MyPlaceCellViewModel) {
        viewModel.imageURL
            .drive(placeImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.category
            .drive(categoryLabel.rx.text)
            .disposed(by: bag)

        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        selectionStyle = .none
    }

    private func layout() {
        [
            placeImageView,
            nameLabel,
            addressLabel,
            categoryLabel,
            boundaryView,
        ].forEach { contentView.addSubview($0) }

        placeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(18.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(112.0)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(22.0)
            $0.height.equalTo(20.0)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22.0)
            $0.top.equalTo(nameLabel.snp.bottom).offset(31.0)
            $0.height.equalTo(15.0)
        }

        addressLabel.snp.makeConstraints {
            $0.centerY.equalTo(categoryLabel.snp.centerY)
            $0.leading.equalTo(categoryLabel.snp.trailing).offset(24.0)
            $0.height.equalTo(15.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
