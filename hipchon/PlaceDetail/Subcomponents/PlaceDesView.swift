//
//  PlaceDesView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import UIKit
import RxSwift

class PlaceDesView: UIView {
    
    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 24.0, type: .bold)
        $0.textColor = .black
    }
    
    private lazy var callButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var callLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.text = "전화"
        $0.textAlignment = .center
    }

    private lazy var shareButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var shareLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.text = "공유"
        $0.textAlignment = .center
    }
    
    private lazy var reviewButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var reviewLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var bookmarkLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }
   
    private lazy var sectorLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
    }
    
    private lazy var businessHoursLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
    }
    
    private lazy var descriptionLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
        $0.numberOfLines = 2
    }
    
    private lazy var linkButton = UIButton().then {
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.titleLabel?.textColor = .primary_green
        $0.backgroundColor = .gray05
        $0.layer.cornerRadius = 22.0
        $0.layer.masksToBounds = true
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PlaceDesViewModel) {
        
        // MARK: view -> viewModel
        linkButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.linkButtonTapped)
            .disposed(by: bag)
        
        // MARK: viewModel -> view
        viewModel.setPlaceName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setReviewCount
            .map { "\($0)" }
            .drive(reviewLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setBookmarkCount
            .map { "\($0)" }
            .drive(bookmarkLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setSector
            .drive(sectorLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setBusinessHours
            .drive(businessHoursLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setDescription
            .drive(descriptionLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setLink
            .drive(linkButton.rx.title())
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
//        roundCorners(corners: [.topLeft, .topRight], radius: 15.0)
    }
    
    private func layout() {
        
        let callStackView = UIStackView(arrangedSubviews: [callButton, callLabel])
        let shareStackView = UIStackView(arrangedSubviews: [shareButton, shareLabel])
        let reviewStackView = UIStackView(arrangedSubviews: [reviewButton, reviewLabel])
        let bookmarkStackView = UIStackView(arrangedSubviews: [bookmarkButton, bookmarkLabel])
        
        [
            callStackView,
            shareStackView,
            reviewStackView,
            bookmarkStackView
        ].forEach {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalCentering
            $0.spacing = 7.0
        }
        
        [
            callButton,
            shareButton,
            reviewButton,
            bookmarkButton
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(30.0)
            }
        }
        
        let buttonStackView = UIStackView(arrangedSubviews: [callStackView,
                                                             shareStackView,
                                                             reviewStackView,
                                                             bookmarkStackView])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 0.0
        
        
        let textStackView = UIStackView(arrangedSubviews: [sectorLabel,
                                                          businessHoursLabel,
                                                           descriptionLabel
                                                          ])
        textStackView.axis = .vertical
        textStackView.alignment = .fill
        textStackView.distribution = .fill
        textStackView.spacing = 25.0
        
        
        [
            placeNameLabel,
            buttonStackView,
            textStackView,
            linkButton
        ].forEach {
            addSubview($0)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(48.0)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(24.0)
            $0.height.equalTo(60.0)
        }
        
        textStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20.0)
        }
        
        linkButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(textStackView.snp.bottom).offset(20.0)
            $0.height.equalTo(44.0)
        }
        
    }
    
}
