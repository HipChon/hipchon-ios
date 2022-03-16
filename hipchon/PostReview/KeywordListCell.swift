//
//  KeywordListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/12.
//

import Foundation
import UIKit
import RxSwift

class KeywordListCell: UICollectionViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
    }

    private lazy var firstKeywordButton = KeywordButton().then { _ in
    }

    private lazy var secondKeywordButton = KeywordButton().then { _ in
    }

    private lazy var thirdKeywordButton = KeywordButton().then { _ in
    }

    private lazy var fourthKeywordButton = KeywordButton().then { _ in
    }

    private lazy var fifthKeywordButton = KeywordButton().then { _ in
    }

    public static let identyfier = "KeywordListCell"
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

    func bind(_ viewModel: KeywordListCellViewModel) {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        // first

        viewModel.firstKeyword
            .compactMap { $0.content }
            .drive(firstKeywordButton.contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.firstKeyword
            .compactMap { $0.iconImage }
            .drive(firstKeywordButton.logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.firstKeywordButtonColor
            .drive(firstKeywordButton.rx.backgroundColor)
            .disposed(by: bag)
        
        firstKeywordButton.rx.tap
            .bind(to: viewModel.firstKeywordButtonTapped)
            .disposed(by: bag)
        
        // second

        viewModel.secondKeyword
            .compactMap { $0.content }
            .drive(secondKeywordButton.contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.secondKeyword
            .compactMap { $0.iconImage }
            .drive(secondKeywordButton.logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.secondKeywordButtonColor
            .drive(secondKeywordButton.rx.backgroundColor)
            .disposed(by: bag)
        
        secondKeywordButton.rx.tap
            .bind(to: viewModel.secondKeywordButtonTapped)
            .disposed(by: bag)
        
        // third

        viewModel.thirdKeyword
            .compactMap { $0.content }
            .drive(thirdKeywordButton.contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.thirdKeyword
            .compactMap { $0.iconImage }
            .drive(thirdKeywordButton.logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.thirdKeywordButtonColor
            .drive(thirdKeywordButton.rx.backgroundColor)
            .disposed(by: bag)
        
        thirdKeywordButton.rx.tap
            .bind(to: viewModel.thirdKeywordButtonTapped)
            .disposed(by: bag)
        
        // fourth

        viewModel.fourthKeyword
            .compactMap { $0.content }
            .drive(fourthKeywordButton.contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.fourthKeyword
            .compactMap { $0.iconImage }
            .drive(fourthKeywordButton.logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.fourthKeywordButtonColor
            .drive(fourthKeywordButton.rx.backgroundColor)
            .disposed(by: bag)
        
        fourthKeywordButton.rx.tap
            .bind(to: viewModel.fourthKeywordButtonTapped)
            .disposed(by: bag)
        
        // fifth

        viewModel.fifthKeyword
            .compactMap { $0.content }
            .drive(fifthKeywordButton.contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.fifthKeyword
            .compactMap { $0.iconImage }
            .drive(fifthKeywordButton.logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.fifthKeywordButtonColor
            .drive(fifthKeywordButton.rx.backgroundColor)
            .disposed(by: bag)
        
        fifthKeywordButton.rx.tap
            .bind(to: viewModel.fifthKeywordButtonTapped)
            .disposed(by: bag)
        
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            titleLabel,
            firstKeywordButton,
            secondKeywordButton,
            thirdKeywordButton,
            fourthKeywordButton,
            fifthKeywordButton,
        ].forEach {
            addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview()
            $0.height.equalTo(19.0)
        }

        firstKeywordButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(16.0)
            $0.width.equalTo(212.0)
            $0.height.equalTo(44.0)
        }

        secondKeywordButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(firstKeywordButton.snp.bottom).offset(8.0)
            $0.width.height.equalTo(firstKeywordButton)
        }

        thirdKeywordButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(secondKeywordButton.snp.bottom).offset(8.0)
            $0.width.height.equalTo(firstKeywordButton)
        }

        fourthKeywordButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(thirdKeywordButton.snp.bottom).offset(8.0)
            $0.width.height.equalTo(firstKeywordButton)
        }

        fifthKeywordButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.top.equalTo(fourthKeywordButton.snp.bottom).offset(8.0)
            $0.width.height.equalTo(firstKeywordButton)
        }
    }
}
