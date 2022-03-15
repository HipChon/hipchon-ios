//
//  NavigationView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/11.
//

import RxSwift
import UIKit

class NavigationView: UIView {
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private let bag = DisposeBag()

    func bind(_ viewModel: NavigationViewModel) {
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.backButtonTapped)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            backButton,
        ].forEach {
            addSubview($0)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28.0)
        }
    }
}
