//
//  CustomerServiceView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import Foundation
import UIKit
import RxSwift

class CustomerServiceView: UIView {
    
    private lazy var counselingLabel = UILabel().then {
        $0.text = "어디서 살지 못 정하셨나요?"
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var counselingButton = UIButton().then {
        $0.backgroundColor = .secondary_yellow
        $0.setTitle("카카오톡 상담하기", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.layer.cornerRadius = 5.0
    }

    private lazy var placeRegisterLabel = UILabel().then {
        $0.text = "고객 지원"
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var placeRegisterButton = UIButton().then {
        $0.backgroundColor = .gray02
        $0.setTitle("공간 등록 문의", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.layer.cornerRadius = 5.0
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: CustomerServiceViewModel) {
        counselingButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.counselingButtonTapped)
            .disposed(by: bag)
        
        placeRegisterButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.placeRegisterButtonTapped)
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        
         [
            counselingLabel,
            counselingButton,
            placeRegisterLabel,
            placeRegisterButton
         ].forEach {
                addSubview($0)
            }
        
        counselingLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(22.0)
            $0.height.equalTo(18.0)
        }
        
        counselingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.top.equalTo(counselingLabel.snp.bottom).offset(14.0)
            $0.height.equalTo(48.0)
        }
        
        placeRegisterLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(counselingButton.snp.bottom).offset(20.0)
            $0.height.equalTo(19.0)
        }
        
        placeRegisterButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.top.equalTo(placeRegisterLabel.snp.bottom).offset(14.0)
            $0.height.equalTo(48.0)
        }

        
        
    }
    
}
