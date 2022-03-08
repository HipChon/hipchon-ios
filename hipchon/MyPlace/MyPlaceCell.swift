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

    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 18.0, type: .bold)
    }

    private lazy var sectorLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }
    
    private lazy var memoButton = UIButton().then {
        $0.layer.cornerRadius = 2.0
        $0.backgroundColor = .primary_green
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
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.category
            .drive(sectorLabel.rx.text)
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
            placeNameLabel,
            addressLabel,
            sectorLabel,
            memoButton,
            boundaryView,
        ].forEach { contentView.addSubview($0) }

        placeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(120.0)
        }

        placeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22.0)
            $0.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(19.0)
        }

        sectorLabel.snp.makeConstraints {
            $0.leading.equalTo(placeNameLabel)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(20.0)
            $0.height.equalTo(17.0)
        }

        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(placeNameLabel)
            $0.top.equalTo(sectorLabel.snp.bottom).offset(208)
            $0.height.equalTo(17.0)
        }
        
        memoButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(placeImageView.snp.bottom).offset(13.0)
            $0.height.equalTo(40.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
