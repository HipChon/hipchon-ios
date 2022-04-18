//
//  OnBoardingViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import AuthenticationServices
import RxSwift
import UIKit

class OnBoardingViewController: UIViewController {
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

        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 0.0)
    }

    private lazy var appleLoginButton = UIButton().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
        $0.setImage(UIImage(named: "apple"), for: .normal)
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .GmarketSans(size: 16.0, type: .medium)

        $0.contentHorizontalAlignment = .left
        $0.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        $0.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 0.0)
    }

    private lazy var guestLoginButton = UIButton().then {
        $0.titleLabel?.font = .GmarketSans(size: 16.0, type: .medium)
        $0.setTitle("힙촌 둘러보기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
    }

    private let bag = DisposeBag()
    let viewModel = OnBoardingViewModel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        bind()
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

    func bind() {
        
        // MARK: App Version Check
        
        rx.viewDidAppear
            .take(1)
            .map { _ in () }
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: {
                AppVersion.shared.compareVersion()
            })
            .disposed(by: bag)
        
        // MARK: view -> viewModel

        kakaoLoginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.kakaoLoginButtonTapped)
            .disposed(by: bag)

        appleLoginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                let appleIDProvider = ASAuthorizationAppleIDProvider()
                let request = appleIDProvider.createRequest()
//                request.requestedScopes = [.fullName, .email]

                let authorizationController = ASAuthorizationController(authorizationRequests: [request])
                authorizationController.delegate = self
                authorizationController.presentationContextProvider = self
                authorizationController.performRequests()
            })
            .disposed(by: bag)

        guestLoginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.guestLoginButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.pushTermsVC
            .emit(onNext: { [weak self] viewModel in
                let termsVC = TermsViewController()
                termsVC.bind(viewModel)
                self?.navigationController?.pushViewController(termsVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.pushMainVC
            .emit(onNext: { [weak self] in
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
            guestLoginButton,
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
            $0.bottom.equalTo(guestLoginButton.snp.top).offset(-8.0)
            $0.height.equalTo(50.0)
        }

        guestLoginButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(25.0)
            $0.height.equalTo(50.0)
        }
    }
}

extension OnBoardingViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
    //  Apple 로그인을 모달 시트
    func presentationAnchor(for _: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }

    // Apple ID 연동 성공 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:

            // 계정 정보 가져오기
            let userIdentifier = appleIDCredential.user
            viewModel.appleId.onNext(userIdentifier.identity)

//            let fullName = appleIDCredential.fullName
//            let email = appleIDCredential.email
//
//            print("User ID : \(userIdentifier)")
//            print("User Email : \(email ?? "")")
//            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
//
//            viewModel.email.onNext(email ?? "")
//            viewModel.name.onNext("\((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
        default:
            break
        }
    }

    // Apple ID 연동 실패 시
    func authorizationController(controller _: ASAuthorizationController, didCompleteWithError _: Error) {
        // Handle error.
    }
}
