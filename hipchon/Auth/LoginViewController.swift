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

class LoginViewController: UIViewController {
    // MARK: Property

    private lazy var mainLogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")

        return imageView
    }()

    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.textContentType = .emailAddress
        textField.autocapitalizationType = .none
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        textField.textContentType = .password
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)

        button.backgroundColor = .blue
        return button
    }()

    private lazy var registerButrton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.backgroundColor = .blue
        return button
    }()

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
