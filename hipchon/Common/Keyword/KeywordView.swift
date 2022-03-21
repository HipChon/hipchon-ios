//
//  KeywordView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/22.
//

import UIKit
import RxSwift

class KeywordView: UIView {
    public lazy var iconImageView = UIImageView().then { _ in
    }

    public lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
    }
    
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
    
    func bind(_ viewModel: KeywordViewModel) {
        
        viewModel.iconImage
            .drive(iconImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.backgroundColor
            .drive(rx.backgroundColor)
            .disposed(by: bag)
    }
    

    private func attribute() {
        layer.cornerRadius = 5.0
    }

    private func layout() {
        [
            iconImageView,
            contentLabel,
        ].forEach {
            addSubview($0)
        }

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(7.5)
            $0.top.bottom.equalToSuperview().inset(4.8)
        }

        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(6.0)
            $0.centerY.equalToSuperview()
        }
    }
}
