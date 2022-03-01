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
        $0.font = .systemFont(ofSize: 18.0, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var regionLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0, weight: .medium)
        $0.textColor = .secondaryLabel
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmark") ?? UIImage(), for: .normal) 
    }
    
    private lazy var firstHashtagView = HashtagView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var secondHashtagView = HashtagView().then {
        $0.backgroundColor = .systemGray6
    }
    
    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0, weight: .medium)
        $0.textColor = .black
    }
    
    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12.0, weight: .medium)
        $0.textColor = .black
    }
    

    public static let identyfier = "HipPlaceCell"
    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        attribute()
        layout()
    }

    func bind(_ viewModel: HipPlaceCellViewModel) {
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
        
        viewModel.bookmarkCount
            .map { "저장 \($0)"}
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.reviewCount
            .map { "후기 \($0)"}
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        layer.masksToBounds = true
        layer.cornerRadius = 2.0
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        backgroundColor = .white
    }

    private func layout() {
        [
            imageView,
            nameLabel,
            regionLabel,
            bookmarkButton,
            firstHashtagView,
            secondHashtagView,
            bookmarkCountLabel,
            reviewCountLabel
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(132.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalTo(imageView.snp.trailing).offset(18.0)
            $0.top.equalToSuperview().inset(22.0)
        }
        
        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(nameLabel)
            $0.top.equalTo(nameLabel.snp.bottom).offset(8.0)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.width.height.equalTo(30.0)
            $0.centerY.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        firstHashtagView.snp.makeConstraints {
            $0.top.equalTo(regionLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(nameLabel)
            $0.height.equalTo(20.0)
            $0.width.equalTo(51.0)
        }
        
        secondHashtagView.snp.makeConstraints {
            $0.top.equalTo(regionLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(firstHashtagView.snp.trailing).offset(4.0)
            $0.height.equalTo(20.0)
            $0.width.equalTo(51.0)
        }
        
        bookmarkCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(150.0)
            $0.bottom.equalToSuperview().inset(12.0)
        }

        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(bookmarkCountLabel.snp.trailing).offset(15.0)
            $0.bottom.equalTo(bookmarkCountLabel)
        }
    }
}
