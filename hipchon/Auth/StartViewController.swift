//
//  StartViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import Foundation
import RxSwift
import UIKit

class StartViewController: UIViewController {
    private lazy var logoImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(named: "loginLogo") ?? UIImage()
    }

    private lazy var registerButton = UIButton().then {
        $0.layer.cornerRadius = 30.0
        $0.backgroundColor = .systemGreen
        $0.setTitle("회원가입", for: .normal)
    }

    private lazy var loginButton = UIButton().then {
        $0.layer.cornerRadius = 30.0
        $0.backgroundColor = .systemGreen
        $0.setTitle("로그인", for: .normal)
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

    func bind(_ viewModel: StartViewModel) {
        // MARK: view -> viewModel

        loginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: bag)

        registerButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.registerButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.pushRegisterVC
            .emit(onNext: { [weak self] viewModel in
                let registerVC = RegisterViewController()
                registerVC.bind(viewModel)
                self?.navigationController?.pushViewController(registerVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.pushLoginVC
            .emit(onNext: { [weak self] viewModel in
                let loginVC = LoginViewController()
                loginVC.bind(viewModel)
                self?.navigationController?.pushViewController(loginVC, animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .black
    }

    private func layout() {
        [
            logoImageView,
            registerButton,
            loginButton,
        ].forEach {
            view.addSubview($0)
        }

        logoImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(175.0 / 390.0)
            $0.height.equalTo(logoImageView.snp.width)
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
        }

        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(60.0)
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(52.0)
        }

        registerButton.snp.makeConstraints {
            $0.leading.trailing.height.centerX.equalTo(loginButton)
            $0.bottom.equalTo(loginButton.snp.top).offset(-8.0)
        }
    }
}
