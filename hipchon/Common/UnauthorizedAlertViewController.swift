//
//  UnauthorizedAlertViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/27.
//

import UIKit
import RxSwift

class UnauthorizedAlertViewController: UIViewController {

    private lazy var insideView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
    }
    
    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "noAuth") ?? UIImage()
    }

    private lazy var label = UILabel().then {
        $0.text = """
로그인이 필요해요
힙촌과 함께하러 가볼까요?!
"""
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .gray04
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    private lazy var loginButton = UIButton().then {
        $0.setTitle("로그인 / 회원가입", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.setBackgroundColor(.primary_green, for: .normal)
    }
    
    private lazy var cancleButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle"), for: .normal)
    }
    
    private let bag = DisposeBag()


    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        attribute()
    }


    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        loginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: {
                guard let alertVC = UIApplication.topViewController() else { return }
                alertVC.dismiss(animated: true, completion: {
                    guard let topVC = UIApplication.topViewController() else { return }
                    topVC.tabBarController?.navigationController?.popToRootViewController(animated: true)
                })
            })
            .disposed(by: bag)
        
        cancleButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: {
                guard let alertVC = UIApplication.topViewController() else { return }
                alertVC.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        insideView.removeGestureRecognizer(tapGesture)
    }

    private func layout() {
        
        view.addSubview(insideView)
        
        insideView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.95)
            $0.width.equalTo(290.0)
            $0.height.equalTo(323.0)
        }
        
        
        [
            cancleButton,
            imageView,
            label,
            loginButton
        ].forEach {
            insideView.addSubview($0)
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.width.height.equalTo(28.0)
        }

        imageView.snp.makeConstraints {
            $0.width.equalTo(167.0)
            $0.height.equalTo(126.0)
            $0.top.equalToSuperview().offset(62.0)
            $0.centerX.equalToSuperview().offset(-10.0)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(16.0)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48.0)
        }
    }
    
    @objc func handleTap(sender _: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}
