//
//  File.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/27.
//

import Foundation
import RxSwift
import UIKit

class SortViewController: UIViewController {
    private lazy var bookmarkOrderButton = UIButton().then {
        $0.setTitle("저장순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var reviewOrderButton = UIButton().then {
        $0.setTitle("후기순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var distanceOrderButton = UIButton().then {
        $0.setTitle("후기순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var searchButton = UIButton().then {
        $0.setTitle("적용", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }

    private let bag = DisposeBag()
    var viewHeight = 278.0

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_: SortViewModel) {}

    private func attribute() {
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        view.backgroundColor = .white
    }

    private func layout() {
        let buttonStackView = UIStackView(arrangedSubviews: [bookmarkOrderButton, reviewOrderButton, distanceOrderButton, searchButton])
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 0.0

        [
            bookmarkOrderButton,
            reviewOrderButton,
            distanceOrderButton,
            searchButton,
        ].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(48.0)
            }
        }

        view.addSubview(buttonStackView)

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(24.0)
        }
    }
}
