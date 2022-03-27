//
//  EmptyView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import UIKit
import RxSwift

class EmptyView: UIView {
    
    private lazy var noResultView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var noResultImageView = UIImageView().then {
        $0.image = UIImage(named: "noResult") ?? UIImage()
    }

    private lazy var noResultLabel = UILabel().then {
        $0.text = "앗! 검색 결과가 없습니다"
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .gray04
        $0.textAlignment = .center
    }
    
    private lazy var noAuthView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var noAuthImageView = UIImageView().then {
        $0.image = UIImage(named: "noAuth") ?? UIImage()
    }

    private lazy var noAuthLabel = UILabel().then {
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
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }
    
    private let bag = DisposeBag()
    var checkAuth: Bool?

    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind() {
        let auth = Singleton.shared.currentUser
            .map { $0.id != nil && (self.checkAuth ?? true) == true }
            .asDriver(onErrorJustReturn: false)
        
        auth
            .drive(noAuthView.rx.isHidden)
            .disposed(by: bag)
        
        auth
            .map { !$0 }
            .drive(noResultView.rx.isHidden)
            .disposed(by: bag)
        
        loginButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .asSignal(onErrorJustReturn: ())
            .emit(onNext: {
                guard let topVC = UIApplication.topViewController() else { return }
                topVC.tabBarController?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        
        [
            noResultView,
            noAuthView,
        ].forEach {
            addSubview($0)
            
            $0.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
        
        
        [
            noResultImageView,
            noResultLabel,
        ].forEach {
            noResultView.addSubview($0)
        }

        noResultImageView.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(156.0 / 723.0)
            $0.width.equalTo(noResultImageView.snp.height).multipliedBy(134.0 / 156.0)
            $0.centerX.equalToSuperview().offset(-10.0)
            $0.centerY.equalToSuperview().multipliedBy(0.84)
        }

        noResultLabel.snp.makeConstraints {
            $0.top.equalTo(noResultImageView.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        [
            noAuthImageView,
            noAuthLabel,
            loginButton,
        ].forEach {
            noAuthView.addSubview($0)
        }
        
        noAuthImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(145.0 / 390.0)
            $0.height.equalTo(noAuthImageView.snp.width).multipliedBy(110.0 / 145.0)
            $0.centerX.equalToSuperview().offset(-10.0)
            $0.centerY.equalToSuperview().multipliedBy(0.7)
        }

        noAuthLabel.snp.makeConstraints {
            $0.top.equalTo(noAuthImageView.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(noAuthLabel.snp.bottom).offset(20.0)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(208.0)
            $0.height.equalTo(48.0)
        }
        
    }
}
