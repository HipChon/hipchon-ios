//
//  EditProfileViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import YPImagePicker

class EditProfileViewController: UIViewController {
    // MARK: Property

    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }
    
    private lazy var setNickNameLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
        $0.text = "닉네임 설정"
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.image = UIImage(named: "profile") ?? UIImage()
        $0.layer.cornerRadius = $0.frame.width / 2
    }
    
    private lazy var profileImageButton = UIButton().then { _ in
    }
    
    private lazy var nickNameTextField = UITextField().then {
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textAlignment = .center
        $0.borderStyle = .none
        $0.text = "닉네임"
        // 밑줄
        let border = CALayer()
        border.frame = CGRect(x: 0, y: $0.frame.size.height-1, width: $0.frame.width, height: 1)
        border.borderWidth = 1
        border.backgroundColor = UIColor.black.cgColor
        $0.layer.addSublayer(border)
    }
    
    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "setting") ?? UIImage(), for: .normal)
    }
    
    private lazy var completeButton = UIButton().then {
        $0.backgroundColor = .gray02
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .medium)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var picker: YPImagePicker = {
        var config = YPImagePickerConfiguration()
        config.isScrollToChangeModesEnabled = true
        config.onlySquareImagesFromCamera = true
        config.usesFrontCamera = false
        config.showsPhotoFilters = true
        config.showsVideoTrimmer = true
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "DefaultYPImagePickerAlbumName"
        config.startOnScreen = YPPickerScreen.library
        config.screens = [.library, .photo]
        config.showsCrop = .none
        config.targetImageSize = YPImageSize.original
        config.overlayView = UIView()
        config.hidesStatusBar = false
        config.hidesBottomBar = false
        config.hidesCancelButton = false
        config.preferredStatusBarStyle = UIStatusBarStyle.default
        config.bottomMenuItemSelectedTextColour = UIColor(red: 38, green: 38, blue: 38)
        config.bottomMenuItemUnSelectedTextColour = UIColor(red: 153, green: 153, blue: 153)
        config.maxCameraZoomFactor = 1.0
        
        config.wordings.libraryTitle = "갤러리"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.wordings.albumsTitle = "앨범"
        config.wordings.filter = "필터"
        config.wordings.done = "확인"
        
        let picker = YPImagePicker(configuration: config)
        return picker
    }()
    
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
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func bind(_ viewModel: EditProfileViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel
        profileImageButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.present(self.picker, animated: true, completion: nil )
            })
            .disposed(by: bag)
        
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.profileImageView.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }

        // MARK: viewModel -> view

        // MARK: scene
        backButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            backButton,
            setNickNameLabel,
            profileImageView,
            profileImageButton,
            nickNameTextField,
            clearButton,
            completeButton
        ].forEach {
            view.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(13.0)
            $0.width.height.equalTo(28.0)
        }
        
        setNickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.bottom.equalTo(profileImageView.snp.top).offset(-55.0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100.0)
        }
        
        profileImageButton.snp.makeConstraints {
            $0.edges.equalTo(profileImageView)
        }
        
        nickNameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(profileImageView.snp.bottom).offset(36.0)
        }
        
        clearButton.snp.makeConstraints {
            $0.trailing.equalTo(nickNameTextField.snp.trailing)
            $0.height.width.equalTo(28.0)
            $0.centerY.equalTo(nickNameTextField)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.bottom.equalTo(clearButton.snp.bottom).offset(115.0)
            $0.height.equalTo(48.0)
        }
    }
}
