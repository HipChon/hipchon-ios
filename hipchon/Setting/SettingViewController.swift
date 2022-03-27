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

    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var navigationView = NavigationView().then { _ in
    }

    private lazy var appSettingLabel = UILabel().then {
        $0.font = .GmarketSans(size: 20.0, type: .medium)
        $0.text = "앱 설정"
        $0.textColor = .black
    }

    private lazy var versionLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.text = "버전 정보"
        $0.textColor = .black
    }

    private lazy var versionInfoLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        $0.textColor = .primary_green
    }

    private lazy var logoutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.contentHorizontalAlignment = .left
    }

    private lazy var withdrawButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.contentHorizontalAlignment = .left
    }

    private lazy var appSettingBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var partnershipLabel = UILabel().then {
        $0.font = .GmarketSans(size: 20.0, type: .medium)
        $0.text = "호스트 및 제휴"
        $0.textColor = .black
    }

    private lazy var partnershipButton = UIButton().then {
        $0.setTitle("제휴 및 제안", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.contentHorizontalAlignment = .left
    }

    private lazy var partnershipBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var customerServiceLabel = UILabel().then {
        $0.font = .GmarketSans(size: 20.0, type: .medium)
        $0.text = "고객센터"
        $0.textColor = .black
    }

    private lazy var customerServiceButton = UIButton().then {
        $0.setTitle("고객센터 문의", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.contentHorizontalAlignment = .left
    }

    private lazy var marginView = UIView().then {
        $0.backgroundColor = .white
    }

    private let bag = DisposeBag()
    var viewModel: SettingViewModel?

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

        self.viewModel = viewModel

        // MARK: view -> viewModel

        logoutButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.logoutButtonTapped)
            .disposed(by: bag)

        withdrawButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.withdrawButtonTapped)
            .disposed(by: bag)

        partnershipButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.partnershipButtonTapped)
            .disposed(by: bag)

        customerServiceButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.customerServiceButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // MARK: scene

        viewModel.logoutPopToOnBoarding
            .emit(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true)
            })
            .disposed(by: bag)

        viewModel.withdrawPopToOnBoarding
            .emit(onNext: { [weak self] in
                self?.navigationController?.popToRootViewController(animated: true, completion: {
                    Singleton.shared.toastAlert.onNext("회원 탈퇴가 완료되었습니다")
                })
            })
            .disposed(by: bag)
        
        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:])
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        [
            navigationView,
            appSettingLabel,
            versionLabel,
            versionInfoLabel,
            logoutButton,
            withdrawButton,
            appSettingBorderView,
            partnershipLabel,
            partnershipButton,
            partnershipBorderView,
            customerServiceLabel,
            customerServiceButton,
            marginView,
        ].forEach {
            contentView.addSubview($0)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }

        appSettingLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom).offset(4.0)
            $0.leading.equalToSuperview().inset(30.0)
        }

        versionLabel.snp.makeConstraints {
            $0.top.equalTo(appSettingLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(27.0)
        }

        versionInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(versionLabel)
            $0.trailing.equalToSuperview().inset(30.0)
        }

        logoutButton.snp.makeConstraints {
            $0.top.equalTo(versionLabel.snp.bottom).offset(9.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(27.0)
        }

        withdrawButton.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(9.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(27.0)
        }

        appSettingBorderView.snp.makeConstraints {
            $0.top.equalTo(withdrawButton.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
        }

        partnershipLabel.snp.makeConstraints {
            $0.top.equalTo(appSettingBorderView.snp.bottom).offset(34.0)
            $0.leading.equalToSuperview().inset(30.0)
        }

        partnershipButton.snp.makeConstraints {
            $0.top.equalTo(partnershipLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(27.0)
        }

        partnershipBorderView.snp.makeConstraints {
            $0.top.equalTo(partnershipButton.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(1.0)
        }

        customerServiceLabel.snp.makeConstraints {
            $0.top.equalTo(partnershipBorderView.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(30.0)
        }

        customerServiceButton.snp.makeConstraints {
            $0.top.equalTo(customerServiceLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(27.0)
        }

        marginView.snp.makeConstraints {
            $0.top.equalTo(customerServiceButton.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
