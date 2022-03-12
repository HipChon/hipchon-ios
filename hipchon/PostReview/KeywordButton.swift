//
//  KeywordView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/12.
//

import Foundation
import UIKit

class KeywordButton: UIButton {
    
    private lazy var logoImageView = UIImageView().then {
        $0.image = UIImage(named: "setting") ?? UIImage()
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
        $0.text = "시설이 깨끗해요"
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func attribute() {
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        backgroundColor = .primary_green
    }
    
    private func layout() {
        [
            logoImageView,
            contentLabel
        ].forEach {
            addSubview($0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(26.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(14.0)
            $0.centerY.equalToSuperview()
        }
    }
}
