//
//  HipPlaceCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxSwift
import UIKit

class HipPlaceCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }

    private lazy var regionLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = UIColor.typography_secondary
    }

    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmark") ?? UIImage(), for: .normal)
    }

    private lazy var keywordView = KeywordView().then { _ in
    }

    private lazy var bookmarkCountImageView = UIImageView().then {
        $0.image = UIImage(named: "bookmarkCount") ?? UIImage()
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var reviewCountImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewCount") ?? UIImage()
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    public static let identyfier = "HipPlaceCell"
    private var bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: HipPlaceCellViewModel) {
        viewModel.keywordVM
            .drive(onNext: { [weak self] viewModel in
                self?.keywordView.bind(viewModel)
            })
            .disposed(by: bag)

        // MARK: view -> viewModel

        bookmarkButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.bookmarkButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.region
            .drive(regionLabel.rx.text)
            .disposed(by: bag)

        viewModel.bookmarkYn
            .compactMap { $0 == true ? UIImage(named: "bookmarkY") : UIImage(named: "bookmarkN") }
            .drive(bookmarkButton.rx.image)
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
        backgroundColor = .white
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 100.0
    }

    private func layout() {
        // MARK: count

        [
            bookmarkCountImageView,
            reviewCountImageView,
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(16.0)
            }
        }

        let countSpacingView = UIView()
        countSpacingView.snp.makeConstraints {
            $0.width.equalTo(frame.width).priority(.low)
        }

        let countStackView = UIStackView(arrangedSubviews: [bookmarkCountImageView, bookmarkCountLabel, reviewCountImageView, reviewCountLabel])
        countStackView.axis = .horizontal
        countStackView.alignment = .fill
        countStackView.distribution = .fill
        countStackView.spacing = 12.0

        [
            imageView,
            nameLabel,
            regionLabel,
            bookmarkButton,
            keywordView,
            countStackView,
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(132.0)
        }

        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(18.0)
            $0.top.equalToSuperview().inset(22.0)
            $0.trailing.equalTo(bookmarkButton.snp.leading).offset(5.0)
        }

        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.0)
        }

        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16.0)
        }

        keywordView.snp.makeConstraints {
            $0.top.equalTo(regionLabel.snp.bottom).offset(12.0)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(28.0)
        }

        countStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(150.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }
    }
}
