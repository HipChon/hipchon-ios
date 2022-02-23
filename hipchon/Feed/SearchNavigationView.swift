//
//  SearchNavigationView.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/19.
//

import Foundation
import RxSwift
import UIKit

class SearchNavigationView: UIView {
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }

    private lazy var filterButton = UIButton().then {
        $0.setImage(UIImage(named: "filter") ?? UIImage(), for: .normal)
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

    func bind(_: SearchNavigationViewModel) {}

    func attribute() {}

    func layout() {
        [
            backButton,
            filterButton,
        ].forEach { addSubview($0) }

        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(27.0)
            $0.width.height.equalTo(30.0)
        }

        filterButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(27.0)
            $0.width.height.equalTo(30.0)
        }
    }
}
