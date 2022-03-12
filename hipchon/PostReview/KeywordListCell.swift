//
//  KeywordListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/12.
//

import Foundation
import UIKit

class KeywordListCell: UICollectionViewCell {
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.text = "시설"
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: KeywordListCellViewModel) {
        
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            titleLabel,
            firstKeywordButton,
            secondKeywordButton,
            thirdKeywordButton,
            fourthKeywordButton,
            fifthKeywordButton
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
