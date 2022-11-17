//
//  KeywordView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/12.
//

import RxSwift
import UIKit

class KeywordButton: UIButton {
    public lazy var logoImageView = UIImageView().then { _ in
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

    private func attribute() {
        backgroundColor = .white
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        layer.cornerRadius = 5.0
    }

    private func layout() {
        [
            logoImageView,
            contentLabel,
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
