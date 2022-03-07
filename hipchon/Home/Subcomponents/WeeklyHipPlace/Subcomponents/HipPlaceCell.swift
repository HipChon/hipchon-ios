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
    
    private lazy var firstHashtagView = RoundLabelView().then {
        $0.label.font = .GmarketSans(size: 10.0, type: .medium)
        $0.label.textColor = .black
        $0.backgroundColor = .gray02
    }
    
    private lazy var secondHashtagView = RoundLabelView().then {
        $0.label.font = .GmarketSans(size: 10.0, type: .medium)
        $0.label.textColor = .black
        $0.backgroundColor = .gray02
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .black
    }
    
    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .black
    }
    

    public static let identyfier = "HipPlaceCell"
    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: HipPlaceCellViewModel) {
        
        firstHashtagView.bind(viewModel.firstHashtagVM)
        secondHashtagView.bind(viewModel.secondHashtagVM)
        
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
            .map { "저장 \($0)"}
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.reviewCount
            .map { "후기 \($0)"}
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
        }
        
        secondHashtagView.snp.makeConstraints {
            $0.top.equalTo(regionLabel.snp.bottom).offset(8.0)
            $0.leading.equalTo(firstHashtagView.snp.trailing).offset(4.0)
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
