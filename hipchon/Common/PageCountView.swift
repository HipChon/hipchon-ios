//
//  PageCountView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxSwift
import UIKit

class PageCountView: UIView {
    private lazy var label = UILabel().then {
        $0.textAlignment = .center
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
        $0.textColor = .white
    }

    private let bag = DisposeBag()

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 9.0
    }

    func bind(_ viewModel: PageCountViewModel) {
        viewModel.setContent
            .drive(label.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
//        backgroundColor = UIColor(red: 0, green: 0, blue: 0, a: 0.5)
        backgroundColor = .black.withAlphaComponent(0.5)
//        alpha = 0.5
    }

    private func layout() {
        addSubview(label)

        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(4.0)
            $0.top.bottom.equalToSuperview().inset(2.0)
        }
    }
}
