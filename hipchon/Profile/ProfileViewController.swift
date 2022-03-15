//
//  ProfileViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ProfileViewController: UIViewController {
    // MARK: Property
    
    private lazy var profileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "default_profile"), for: .normal)
        $0.layer.masksToBounds = true
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 20.0, type: .bold)
        $0.text = "김범수"
    }
    
    private lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(named: "setting") ?? UIImage(), for: .normal)
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
    }

    func bind(_ viewModel: ProfileViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        settingButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.settingButtonTapped)
            .disposed(by: bag)
        
        profileImageButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.profileImageButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view
        
        // MARK: scene

        viewModel.pushSettingVC
            .emit(onNext: { [weak self] viewModel in
                let settingVC = SettingViewController()
                settingVC.bind(viewModel)
                self?.navigationController?.pushViewController(settingVC, animated: true)
            })
            .disposed(by: bag)
        
        viewModel.pushEditProfileVC
            .emit(onNext: { [weak self] viewModel in
                let editProfileVC = EditProfileViewController()
                editProfileVC.bind(viewModel)
                self?.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            profileImageButton,
            nameLabel,
            settingButton,
        ].forEach { view.addSubview($0) }

        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(79.0)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageButton)
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(16.0)
        }
        
        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18.0)
            $0.width.height.equalTo(28.0)
        }



    }
}
