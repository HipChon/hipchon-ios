//
//  KeywordDetailView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import RxSwift
import UIKit

class KeywordDetailView: UIView {
    private lazy var iconImageView = UIImageView().then { _ in
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
    }

    private lazy var countLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .semibold)
        $0.textColor = .black
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

    func bind(_ viewModel: KeywordDetailViewModel) {
        viewModel.iconImage
            .drive(iconImageView.rx.image)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)

        viewModel.count
            .map { "+\($0)" }
            .drive(countLabel.rx.text)
            .disposed(by: bag)

        viewModel.backgroundColor
            .drive(rx.backgroundColor)
            .disposed(by: bag)
    }

    private func attribute() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
    }

    private func layout() {
        [
            iconImageView,
            contentLabel,
            countLabel,
        ].forEach {
            addSubview($0)
        }

        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(8.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28.0)
        }

        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.trailing).offset(8.0)
            $0.centerY.equalToSuperview()
        }

        countLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
        }
    }
}
