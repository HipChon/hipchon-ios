//
//  HashtagReivewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxSwift
import UIKit

class HashtagReviewCell: UICollectionViewCell {
    private lazy var insideView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 8.0
        $0.addShadow(offset: CGSize(width: 2.0, height: 2.0))
    }

    private lazy var imageView = UIImageView().then { _ in
    }

    private lazy var nameView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .semibold)
        $0.textColor = .black
    }

    private lazy var hashtagImageView = UIImageView().then { _ in
    }

    private lazy var dotButton = UIButton().then {
        $0.setImage(UIImage(named: "dots"), for: .normal)
    }

    public static let identyfier = "HashtagReviewCell"
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

    func bind(_ viewModel: HashtagReviewCellViewModel) {
        viewModel.imageURL
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.hashtagImageURL
            .drive(hashtagImageView.rx.setImageKF)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        contentView.addSubview(insideView)

        insideView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4.0)
        }

        [
            imageView,
            nameView,
            hashtagImageView,
            dotButton,
        ].forEach {
            insideView.addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nameView.snp.top)
        }

        nameView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48.0)
        }

        nameView.addSubview(nameLabel)

        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13.0)
            $0.centerY.equalToSuperview()
        }

        hashtagImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(11.0)
            $0.bottom.equalTo(nameView.snp.top).inset(10.0)
            $0.height.equalToSuperview().multipliedBy(0.4)
            $0.width.equalTo(hashtagImageView.snp.height).multipliedBy(58.0 / 77.0)
        }

        dotButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13.0)
            $0.centerY.equalTo(nameLabel)
            $0.width.equalTo(17.0)
            $0.height.equalTo(4)
        }
    }
}
