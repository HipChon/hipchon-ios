//
//  InputCommentView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import Foundation
import RxSwift
import UIKit

class InputCommentView: UIView {
    private lazy var profileImageView = UIImageView().then {
        $0.image = UIImage(named: "default_profile")! // TODO:
        $0.layer.masksToBounds = true
    }

    private lazy var contentTextField = UITextField().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.placeholder = "댓글 달기 ..."
        $0.layer.cornerRadius = 25.0
        $0.layer.borderColor = UIColor.gray_border.cgColor
        $0.layer.borderWidth = 1.0
        $0.addPadding(location: .left, width: 15.0)
        $0.addPadding(location: .right, width: 50.0)
    }

    private lazy var registerButton = UIButton().then {
        $0.setTitle("등록", for: .normal)
        $0.setTitleColor(.primary_green, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    func bind(_ viewModel: InputCommentViewModel) {
        contentTextField.rx.text.orEmpty
            .bind(to: viewModel.content)
            .disposed(by: bag)

        registerButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.registerButtonTapped)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        addShadow(location: .top)
    }

    private func layout() {
        [
            profileImageView,
            contentTextField,
            registerButton,
        ].forEach {
            addSubview($0)
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(16.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(40.0)
        }

        contentTextField.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.centerY.equalToSuperview()
            $0.height.equalTo(50.0)
        }

        registerButton.snp.makeConstraints {
            $0.trailing.equalTo(contentTextField.snp.trailing).inset(17.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(25.0)
        }
    }
}
