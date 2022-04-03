//
//  UnathorizedEnptyView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/30.
//

import RxSwift
import UIKit

class UnathorizedEnptyView: UIView {
    private lazy var noResultView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var noResultImageView = UIImageView().then {
        $0.image = UIImage(named: "noResult") ?? UIImage()
    }

    private lazy var noResultLabel = UILabel().then {
        $0.text = "앗! 검색 결과가 없습니다"
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .gray04
        $0.textAlignment = .center
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {}

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            noResultView,
        ].forEach {
            addSubview($0)

            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }

        [
            noResultImageView,
            noResultLabel,
        ].forEach {
            noResultView.addSubview($0)
        }

        noResultImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(134.0 / 390.0)
//            $0.height.equalToSuperview().multipliedBy(156.0 / 723.0)
            $0.height.equalTo(noResultImageView.snp.width).multipliedBy(156.0 / 134.0)
            $0.centerX.equalToSuperview().offset(-10.0)
            $0.centerY.equalToSuperview().multipliedBy(0.84)
        }

        noResultLabel.snp.makeConstraints {
            $0.top.equalTo(noResultImageView.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
    }
}
