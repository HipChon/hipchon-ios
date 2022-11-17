//
//  HomeSearchView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import RxSwift
import UIKit

class HomeSearchView: UIView {
    private lazy var searchButton = SearchFilterButton().then {
        $0.setTitle("지역, 유형을 검색하세요", for: .normal)
        $0.setTitleColor(.secondaryLabel, for: .normal)
        $0.titleLabel?.font = UIFont(name: "GmarketSansTTFMedium", size: 14.0)
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 54.0, bottom: 0.0, right: 0.0)
    }

    private lazy var searchImageView = UIImageView().then {
        $0.image = UIImage(named: "search") ?? UIImage()
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
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

    func bind(_ viewModel: HomeSearchViewModel) {
        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            searchButton,
            searchImageView,
            boundaryView,
        ].forEach {
            addSubview($0)
        }

        searchButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(44.0)
        }

        searchImageView.snp.makeConstraints {
            $0.centerY.equalTo(searchButton)
            $0.leading.equalTo(searchButton.snp.leading).offset(20.0)
            $0.height.width.equalTo(16.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
