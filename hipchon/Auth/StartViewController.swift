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
    
    private lazy var mainTitleLabel = UILabel().then {
        let text = """
촌스러운 것이
힙하다
"""
        $0.text = text

        $0.numberOfLines = 2
        $0.textColor = .white
        $0.font = .GmarketSans(size: 40.0, type: .medium)
        

        let attributeText = NSMutableAttributedString(string: text)
        let attributes: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.primary_green]
        attributeText.addAttributes(attributes, range: NSRange(location: 0, length: 1))
        attributeText.addAttributes(attributes, range: NSRange(location: 8, length: 1))
        $0.attributedText = attributeText
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = "힙촌과 함께 떠나보아요"
        $0.textColor = .white
        $0.font = .GmarketSans(size: 14.0, type: .medium)
    }
    
    private lazy var peopleImageView = UIImageView().then {
        $0.image = UIImage(named: "people") ?? UIImage()
    }
    
    private lazy var kakaoLoginButton = UIButton().then {
        $0.backgroundColor = .kakao_yellow
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
        $0.setImage(UIImage(named: "kakao"), for: .normal)
        $0.setTitle("카카오 계정으로 시작하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .GmarketSans(size: 16.0, type: .medium)
    }
    
    private lazy var appleLoginButton = UIButton().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
        $0.setImage(UIImage(named: "apple"), for: .normal)
        $0.setTitle("애플 계정으로 시작하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .GmarketSans(size: 16.0, type: .medium)
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: StartViewModel) {
        // MARK: view -> viewModel

//        loginButton.rx.tap
//            .throttle(.seconds(2), scheduler: MainScheduler.instance)
//            .bind(to: viewModel.loginButtonTapped)
//            .disposed(by: bag)
//
//        registerButton.rx.tap
//            .throttle(.seconds(2), scheduler: MainScheduler.instance)
//            .bind(to: viewModel.registerButtonTapped)
//            .disposed(by: bag)

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
//                let loginVC = LoginViewController()
//                loginVC.bind(viewModel)
//                self?.navigationController?.pushViewController(loginVC, animated: true)
                
                let tapBarViewController = TabBarViewController()
                self?.navigationController?.pushViewController(tapBarViewController, animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .black
    }

    private func layout() {
        [
            mainTitleLabel,
            subTitleLabel,
            peopleImageView,
            kakaoLoginButton,
            appleLoginButton,
        ].forEach {
            view.addSubview($0)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.centerY.equalToSuperview().multipliedBy(0.4)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(mainTitleLabel)
            $0.top.equalTo(mainTitleLabel.snp.bottom).offset(21.0)

        }

        peopleImageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(kakaoLoginButton.snp.top).offset(-8.0)
            $0.width.equalTo(188.0)
            $0.height.equalTo(145.0)
        }
        
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.bottom.equalTo(appleLoginButton.snp.top).offset(-8.0)
            $0.height.equalTo(50.0)
        }
        
        appleLoginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(30.0)
            $0.height.equalTo(50.0)
        }
    }
}
