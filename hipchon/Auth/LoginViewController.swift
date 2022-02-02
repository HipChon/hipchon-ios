//
//  LoginViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import Then

class LoginViewController: UIViewController {
    // MARK: Property

    private lazy var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(systemName: "heart.fill")
    }

    private lazy var emailTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.textContentType = .emailAddress
        $0.autocapitalizationType = .none
    }

    private lazy var passwordTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.isSecureTextEntry = true
        $0.textContentType = .password
    }

    private lazy var loginButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightText, for: .highlighted)
        $0.backgroundColor = .tintColor
    }

    private lazy var registerButrton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setTitleColor(.lightText, for: .highlighted)
        $0.backgroundColor = .tintColor
    }


    private var bag = DisposeBag()
    let viewModel = LoginViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(viewModel)
        attribute()
        layout()
    }

    func bind(_ viewModel: LoginViewModel) {
        // MARK: view -> viewModel

        emailTextField.rx.text
            .orEmpty
            .bind(to: viewModel.email)
            .disposed(by: bag)

        passwordTextField.rx.text
            .orEmpty
            .bind(to: viewModel.password)
            .disposed(by: bag)

        // MARK: viewModel -> view

//        viewModel.loginValid
//            .drive(loginButton.rx.isEnabled)
//            .disposed(by: bag)

        viewModel.loginValid
            .map { $0 == true ? 1.0 : 0.3 }
            .drive(loginButton.rx.alpha)
            .disposed(by: bag)

        // MARK: scene

        loginButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                let homeVC = HomeViewController()
                homeVC.modalPresentationStyle = .fullScreen
                self?.present(homeVC, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    func attribute() {
        [
            loginButton,
            registerButrton,
        ].forEach { $0.layer.cornerRadius = 8.0 }
    }

    func layout() {
        let textFieldStackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField])
        let buttonStackView = UIStackView(arrangedSubviews: [loginButton, registerButrton])

        [textFieldStackView,
         buttonStackView].forEach {
            $0.axis = .vertical
            $0.distribution = .fillEqually
            $0.spacing = 4.0
        }

        [
            mainLogoImageView,
            textFieldStackView,
            buttonStackView,
        ].forEach {
            view.addSubview($0)
        }

        mainLogoImageView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.width.height.equalTo(300.0)
        }

        textFieldStackView.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(84.0)
        }

        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(textFieldStackView.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(64.0)
        }
    }
}
