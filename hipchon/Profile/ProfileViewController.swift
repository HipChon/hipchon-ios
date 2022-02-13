//
//  ProfileViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ProfileViewController: UIViewController {
    // MARK: Property
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(systemName: "house"), for: .normal)
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        attribute()
    }

    func bind(_ viewModel: ProfileViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel
        settingButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.settingButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // MARK: scene
        viewModel.pushSettingVC
            .emit(onNext: { [weak self] viewModel in
                let settingVC = SettingViewController()
                settingVC.bind(viewModel)
                self?.navigationController?.pushViewController(settingVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    func layout() {
        [
            settingButton
        ].forEach { view.addSubview($0) }
        
        settingButton.snp.makeConstraints {
            $0.height.width.equalTo(30.0)
            $0.top.trailing.equalToSuperview().inset(30)
        }
    }
}
