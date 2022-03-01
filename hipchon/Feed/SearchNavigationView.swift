//
//  SearchNavigationView.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/19.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class SearchNavigationView: UIView {
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }

    private lazy var searchFilterButton = SearchFilterButton(frame: .zero).then { _ in
    }

    private lazy var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "sort") ?? UIImage(), for: .normal)
    }
    
    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray_border
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

    func bind(_ viewModel: SearchNavigationViewModel) {
        // MARK: view -> viewModel

        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.backButtonTapped)
            .disposed(by: bag)

        searchFilterButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchFilterButtonTapped)
            .disposed(by: bag)

        sortButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.sortButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.setSearchFilterTitle
            .drive(searchFilterButton.rx.title())
            .disposed(by: bag)
    }

    func attribute() {}

    func layout() {
        [
            backButton,
            searchFilterButton,
            sortButton,
            boundaryView
        ].forEach { addSubview($0) }

        backButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(27.0)
            $0.width.height.equalTo(30.0)
        }

        searchFilterButton.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.equalTo(224.0)
            $0.height.equalTo(44.0)
        }

        sortButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(27.0)
            $0.width.height.equalTo(30.0)
        }
        
        boundaryView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
