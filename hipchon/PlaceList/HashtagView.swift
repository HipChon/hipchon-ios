//
//  HashtagView.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/26.
//

import Foundation
import RxSwift
import UIKit

class HashtagView: UIView {
    private lazy var label = UILabel().then {
        $0.font = .systemFont(ofSize: 10.0, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
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

    func bind(_ viewModel: HashtagViewModel) {
        viewModel.setHashtag
            .drive(label.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        layer.cornerRadius = 12.0
    }

    private func layout() {
        [
            label,
        ].forEach {
            addSubview($0)
        }

        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
