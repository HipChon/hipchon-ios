//
//  SettingViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SettingViewController: UIViewController {
    // MARK: Property
    
    private lazy var navigationView = NavigationView().then { _ in
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: SettingViewModel) {
        // MARK: subViews Binding
 
        // MARK: view -> viewModel

        // MARK: viewModel -> view

        // MARK: scene

    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            navigationView
        ].forEach {
            view.addSubview($0)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }
    }
}
