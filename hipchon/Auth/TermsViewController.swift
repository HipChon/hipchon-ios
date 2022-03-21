//
//  TermsViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/21.
//

import RxCocoa
import UIKit
import RxSwift

class TermsViewController: UIViewController {
    
    private lazy var navigationView = NavigationView().then { _ in
    }
    
    private lazy var termLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
        $0.textColor = .black
        $0.text = "약관 동의"
    }
    
    private lazy var entireCheckButton = UIButton().then { _ in
    }
    
    private lazy var entireLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "전체 동의합니다"
    }
    
    private lazy var borderView = UIView().then {
        $0.backgroundColor = .gray_border
    }
    
    private lazy var ageCheckButton = UIButton().then { _ in
    }
    
    private lazy var ageLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "만 14세 이상입니다 (필수)"
    }
    
    private lazy var serviceCheckButton = UIButton().then { _ in
    }
    
    private lazy var serviceLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "서비스 이용약관 (필수)"
    }
    
    private lazy var privacyCheckButton = UIButton().then { _ in
    }
    
    private lazy var privacyLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "개인정보 수집 및 이용 동의 (필수)"
    }
    
    private lazy var positionCheckButton = UIButton().then { _ in
    }
    
    private lazy var positionLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "위치서비스 이용 동의 (필수)"
    }
    
    private lazy var maketingCheckButton = UIButton().then { _ in
    }
    
    private lazy var maketingLabel = UILabel().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.text = "이벤트 및 할인 혜택 안내 동의 (선택)"
    }
    
    private lazy var completeButton = UIButton().then {
        $0.backgroundColor = .primary_green
        $0.layer.cornerRadius = 5.0
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .GmarketSans(size: 16.0, type: .medium)
    }
    
    private let bag = DisposeBag()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: TermsViewModel) {
        
        // MARK: view -> viewModel
        
        entireCheckButton.rx.tap
            .bind(to: viewModel.entireCheckButtonTapped)
            .disposed(by: bag)
        
        ageCheckButton.rx.tap
            .bind(to: viewModel.ageCheckButtonTapped)
            .disposed(by: bag)
        
        serviceCheckButton.rx.tap
            .bind(to: viewModel.serviceCheckButtonTapped)
            .disposed(by: bag)
        
        privacyCheckButton.rx.tap
            .bind(to: viewModel.privacyCheckButtonTapped)
            .disposed(by: bag)
        
        positionCheckButton.rx.tap
            .bind(to: viewModel.positionCheckButtonTapped)
            .disposed(by: bag)
        
        maketingCheckButton.rx.tap
            .bind(to: viewModel.maketingCheckButtonTapped)
            .disposed(by: bag)
        
        completeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.completeButtonTapped)
            .disposed(by: bag)
        
        // MARK: viewModel -> view
        
        viewModel.setEntireAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(entireCheckButton.rx.image)
            .disposed(by: bag)
        
        viewModel.setAgeAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(ageCheckButton.rx.image)
            .disposed(by: bag)
        
        viewModel.setServiceAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(serviceCheckButton.rx.image)
            .disposed(by: bag)
        
        viewModel.setPrivacyAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(privacyCheckButton.rx.image)
            .disposed(by: bag)
        
        viewModel.setPositionAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(positionCheckButton.rx.image)
            .disposed(by: bag)
        
        viewModel.setMaketingAgree
            .compactMap { $0 ? UIImage(named: "check") : UIImage(named: "nonCheck") }
            .drive(maketingCheckButton.rx.image)
            .disposed(by: bag)
        
        // MARK: scene
        
        viewModel.pushEditProfileVC
            .emit(onNext: { [weak self] viewModel in
                let editProfileVC = EditProfileViewController()
                editProfileVC.bind(viewModel)
                self?.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .disposed(by: bag)
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [
            navigationView,
            termLabel,
            entireCheckButton,
            entireLabel,
            borderView,
            ageCheckButton,
            ageLabel,
            serviceCheckButton,
            serviceLabel,
            privacyCheckButton,
            privacyLabel,
            positionCheckButton,
            positionLabel,
            maketingCheckButton,
            maketingLabel,
            completeButton,
        ].forEach {
            view.addSubview($0)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationView.viewHeight)
        }
        
        termLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.top.equalTo(navigationView.snp.bottom).offset(43.0)
        }
        
        entireCheckButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(termLabel.snp.bottom).offset(36.0)
            $0.width.height.equalTo(28.0)
        }
        
        entireLabel.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(entireCheckButton)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(entireCheckButton.snp.bottom).offset(12.0)
            $0.height.equalTo(1.0)
        }
        
        ageCheckButton.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton)
            $0.top.equalTo(borderView.snp.bottom).offset(32.0)
            $0.width.height.equalTo(entireCheckButton)
        }
        
        ageLabel.snp.makeConstraints {
            $0.leading.equalTo(ageCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(ageCheckButton)
        }
        
        serviceCheckButton.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton)
            $0.top.equalTo(ageCheckButton.snp.bottom).offset(16.0)
            $0.width.height.equalTo(entireCheckButton)
        }
        
        serviceLabel.snp.makeConstraints {
            $0.leading.equalTo(serviceCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(serviceCheckButton)
        }
        
        privacyCheckButton.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton)
            $0.top.equalTo(serviceCheckButton.snp.bottom).offset(16.0)
            $0.width.height.equalTo(entireCheckButton)
        }
        
        privacyLabel.snp.makeConstraints {
            $0.leading.equalTo(privacyCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(privacyCheckButton)
        }
        
        positionCheckButton.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton)
            $0.top.equalTo(privacyCheckButton.snp.bottom).offset(16.0)
            $0.width.height.equalTo(entireCheckButton)
        }
        
        positionLabel.snp.makeConstraints {
            $0.leading.equalTo(positionCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(positionCheckButton)
        }

        maketingCheckButton.snp.makeConstraints {
            $0.leading.equalTo(entireCheckButton)
            $0.top.equalTo(positionCheckButton.snp.bottom).offset(16.0)
            $0.width.height.equalTo(entireCheckButton)
        }
        
        maketingLabel.snp.makeConstraints {
            $0.leading.equalTo(maketingCheckButton.snp.trailing).offset(22.0)
            $0.centerY.equalTo(maketingCheckButton)
        }
        
        completeButton.snp.makeConstraints {
            $0.top.equalTo(maketingCheckButton.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(50.0)
        }
    }
    
}
