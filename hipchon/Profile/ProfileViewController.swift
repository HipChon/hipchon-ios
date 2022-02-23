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

    private lazy var backgroundImageView = UIImageView().then {
        $0.backgroundColor = .gray
    }

    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "profile") ?? UIImage()
        $0.layer.cornerRadius = $0.frame.width / 2
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20.0, weight: .bold)
        $0.text = "김범수"
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
            backgroundImageView,
            settingButton,
            profileImageView,
            nameLabel,
        ].forEach { view.addSubview($0) }

        settingButton.snp.makeConstraints {
            $0.height.width.equalTo(30.0)
            $0.top.trailing.equalToSuperview().inset(30)
        }

        backgroundImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.snp.width).multipliedBy(186.0 / 390.0)
        }

        profileImageView.snp.makeConstraints {
            $0.width.equalTo(view.snp.width).multipliedBy(106.0 / 390.0)
            $0.height.equalTo(profileImageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(backgroundImageView.snp.bottom).offset(26.0)
        }
    }
}
