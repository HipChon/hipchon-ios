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
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray06
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray06
    }

    private lazy var bookmarkImageView = UIImageView().then {
        $0.image = UIImage(named: "bookmarkCount") ?? UIImage()
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var reviewImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewCount") ?? UIImage()
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var memoButton = UIButton().then {
        $0.layer.cornerRadius = 2.0
        $0.backgroundColor = .primary_green
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
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

        viewModel.sector
            .drive(sectorLabel.rx.text)
            .disposed(by: bag)

        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: bag)

        viewModel.bookmarkCount
            .map { "\($0)" }
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewCount
            .map { "\($0)" }
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        selectionStyle = .none
    }

    private func layout() {
        // MARK: count

        [
            bookmarkImageView,
            reviewImageView,
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(20.0)
            }
        }

        let countSpacingView = UIView()
        countSpacingView.snp.makeConstraints {
            $0.width.equalTo(frame.width).priority(.low)
        }

        let countStackView = UIStackView(arrangedSubviews: [bookmarkImageView, bookmarkCountLabel, reviewImageView, reviewCountLabel])
        countStackView.axis = .horizontal
        countStackView.alignment = .fill
        countStackView.distribution = .fill
        countStackView.spacing = 12.0

        [
            placeImageView,
            placeNameLabel,
            sectorLabel,
            addressLabel,
            countStackView,
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
            $0.trailing.equalTo(placeImageView.snp.leading).offset(-16.0)
            $0.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(19.0)
        }

        sectorLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeNameLabel)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(20.0)
            $0.height.equalTo(17.0)
        }

        addressLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeNameLabel)
            $0.top.equalTo(sectorLabel.snp.bottom).offset(8)
            $0.height.equalTo(17.0)
        }

        countStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(addressLabel.snp.bottom).offset(8.0)
            $0.height.equalTo(20.0)
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
