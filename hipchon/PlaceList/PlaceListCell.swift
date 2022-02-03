//
//  PlaceListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import UIKit

class PlaceListCell: UITableViewCell {
    private lazy var nameLabel = UILabel().then {
        $0.textColor = .red
        $0.sizeToFit()
    }

    private lazy var addressLabel = UILabel().then {
        $0.textColor = .blue
        $0.sizeToFit()
    }

    private lazy var priceLabel = UILabel().then {
        $0.textColor = .green
        $0.sizeToFit()
    }

    public static let identyfier = "PlaceListCell"
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

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func bind(_ viewModel: PlaceListCellViewModel) {
        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: bag)

        viewModel.price
            .drive(priceLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.layer.cornerRadius = 12.0
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.backgroundColor = .white
        selectionStyle = .none
    }

    private func layout() {
        [
            nameLabel,
            addressLabel,
            priceLabel,

        ].forEach { contentView.addSubview($0) }

        nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }

        priceLabel.snp.makeConstraints {
            $0.top.equalTo(addressLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }
    }
}
