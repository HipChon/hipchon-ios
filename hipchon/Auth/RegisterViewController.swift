//
//  RegisterViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import RxCocoa
import UIKit
import RxSwift

class RegisterViewController: UIViewController {
    
    private let bag = DisposeBag()
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }
    
    private lazy var registerLabel = UILabel().then {
        $0.text = "이메일로 회원가입"
        $0.font = .systemFont(ofSize: 22.0, weight: .regular)
    }
    
    // MARK: email
    
    private lazy var emailLabel = UILabel().then {
        $0.text = "이메일"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
    
    private lazy var emailTextField = UITextField().then {
        $0.placeholder = "hipchon@gmail.com"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.keyboardType = .emailAddress
    }
    
    private lazy var emailCheckImageView = UIImageView().then {
        $0.image = UIImage(named: "check") ?? UIImage()
        $0.isHidden = true
    }
    
    private lazy var emailValidView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var emailValidLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.text = "올바르지 않은 이메일 형식입니다"
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    // MARK: password
    
    private lazy var passwordLabel = UILabel().then {
        $0.text = "비밀번호"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
    
    private lazy var passwordTextField = UITextField().then {
        $0.placeholder = "영문, 숫자, 특수문자"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.isSecureTextEntry = true
    }
    
    private lazy var passwordCheckImageView = UIImageView().then {
        $0.image = UIImage(named: "check") ?? UIImage()
        $0.isHidden = true
    }
    
    private lazy var passwordValidView = UIView().then {
        $0.backgroundColor = .lightGray
    }
    
    private lazy var passwordValidLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .medium)
        $0.text = "올바르지 않은 비밀번호 형식입니다"
        $0.textColor = .systemRed
        $0.isHidden = true
    }
    
    private lazy var regitserButton = UIButton().then {
        $0.backgroundColor = .systemGreen
        $0.layer.cornerRadius = 5.0
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .medium)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        attribute()
    }
    
    func bind(_ viewModel: RegisterViewModel) {
        // MARK: email
        
        emailTextField.rx.text.orEmpty
            .bind(to: viewModel.email)
            .disposed(by: bag)
        
        let emailValidColor = Signal.merge(
            emailTextField.rx.controlEvent(.editingDidBegin)
                .take(1)
                .map { UIColor.systemGreen }
                .asSignal(onErrorJustReturn: UIColor.systemGreen),

            emailTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(viewModel.emailValid)
                .filter { $0 == true }
                .map { _ in UIColor.lightGray }
                .asSignal(onErrorJustReturn: UIColor.lightGray),
            
            viewModel.emailValid
                .map { $0 == true ? UIColor.systemGreen : UIColor.systemRed }
        )
        
        emailValidColor
            .emit(to: emailValidView.rx.backgroundColor)
            .disposed(by: bag)
        
        emailValidColor
            .emit(to: emailLabel.rx.textColor)
            .disposed(by: bag)
        
        viewModel.emailValid
            .emit(to: emailValidLabel.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.emailValid
            .map { !$0 }
            .emit(to: emailCheckImageView.rx.isHidden)
            .disposed(by: bag)
        
        // MARK: password
        
        passwordTextField.rx.text.orEmpty
            .bind(to: viewModel.password)
            .disposed(by: bag)
        
        let passwordValidColor = Signal.merge(
            passwordTextField.rx.controlEvent(.editingDidBegin)
                .take(1)
                .map { UIColor.systemGreen }
                .asSignal(onErrorJustReturn: UIColor.systemGreen),

            passwordTextField.rx.controlEvent(.editingDidEnd)
                .withLatestFrom(viewModel.passwordValid)
                .filter { $0 == true }
                .map { _ in UIColor.lightGray }
                .asSignal(onErrorJustReturn: UIColor.lightGray),

            viewModel.passwordValid
                .map { $0 == true ? UIColor.systemGreen : UIColor.red }
        )
        
        passwordValidColor
            .emit(to: passwordValidView.rx.backgroundColor)
            .disposed(by: bag)
        
        passwordValidColor
            .emit(to: passwordLabel.rx.textColor)
            .disposed(by: bag)
        
        viewModel.passwordValid
            .emit(to: passwordValidLabel.rx.isHidden)
            .disposed(by: bag)
        
        viewModel.passwordValid
            .map { !$0 }
            .emit(to: passwordCheckImageView.rx.isHidden)
            .disposed(by: bag)

        viewModel.passwordWrongType
            .distinctUntilChanged()
            .map { type -> String in
                switch type {
                case .right:
                    return ""
                case .length:
                    return "8자리 이상의 비밀번호를 설정해주세요"
                case .combination:
                    return "영문과 숫자를 혼합하여 설정해주세요"
                case .special:
                    return "특수문자(!@# 등)를 추가해주세요"
                }
            }
            .drive(passwordValidLabel.rx.text)
            .disposed(by: bag)

      
        viewModel.registerButtonValid
            .drive(regitserButton.rx.validUI)
            .disposed(by: bag)
        
        // MARK: scene
        
        backButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    private func attribute() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
    }
    
    private func layout() {
        [
            backButton,
            registerLabel,
        ].forEach {
            view.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.width.equalTo(30.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20.0)
        }
        
        registerLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.top.equalTo(backButton.snp.bottom).offset(60.0)
        }
        
        // MARK: email
        
        [
            emailLabel,
            emailTextField,
            emailCheckImageView,
            emailValidView,
            emailValidLabel
        ].forEach {
            view.addSubview($0)
        }
        
        emailLabel.snp.makeConstraints {
            $0.leading.equalTo(registerLabel)
            $0.top.equalTo(registerLabel.snp.bottom).offset(30.0)
        }
        
        emailTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.top.equalTo(emailLabel.snp.bottom)
            $0.height.equalTo(48.0)
        }
        
        emailCheckImageView.snp.makeConstraints {
            $0.centerY.equalTo(emailTextField)
            $0.trailing.equalTo(emailTextField).inset(5.0)
        }
        
        emailValidView.snp.makeConstraints {
            $0.leading.trailing.equalTo(emailTextField)
            $0.top.equalTo(emailTextField.snp.bottom)
            $0.height.equalTo(1.0)
        }
        
        emailValidLabel.snp.makeConstraints {
            $0.leading.equalTo(emailValidView)
            $0.top.equalTo(emailValidView.snp.bottom).offset(8.0)
        }
        
        // MARK: password
        
        [
            passwordLabel,
            passwordTextField,
            passwordCheckImageView,
            passwordValidView,
            passwordValidLabel
        ].forEach {
            view.addSubview($0)
        }
        
        passwordLabel.snp.makeConstraints {
            $0.leading.equalTo(registerLabel)
            $0.top.equalTo(emailValidLabel.snp.bottom).offset(36.0)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.top.equalTo(passwordLabel.snp.bottom)
            $0.height.equalTo(48.0)
        }
        
        passwordCheckImageView.snp.makeConstraints {
            $0.centerY.equalTo(passwordTextField)
            $0.trailing.equalTo(passwordTextField).inset(5.0)
        }
        
        passwordValidView.snp.makeConstraints {
            $0.leading.trailing.equalTo(passwordTextField)
            $0.top.equalTo(passwordTextField.snp.bottom)
            $0.height.equalTo(1.0)
        }
        
        passwordValidLabel.snp.makeConstraints {
            $0.leading.equalTo(passwordValidView)
            $0.top.equalTo(passwordValidView.snp.bottom).offset(8.0)
        }
        
        [
            regitserButton
        ].forEach {
            view.addSubview($0)
        }
        
        regitserButton.snp.makeConstraints {
            $0.height.equalTo(45.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(passwordValidLabel.snp.bottom).offset(30.0)
        }
        
    }
}
