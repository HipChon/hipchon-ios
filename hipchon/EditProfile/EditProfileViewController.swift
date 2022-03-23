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

    private lazy var navigationView = NavigationView().then { _ in
    }

    private lazy var setNickNameLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
        $0.text = "닉네임 설정"
    }

    private lazy var profileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "default_profile"), for: .normal)
        $0.layer.masksToBounds = true
    }

    private lazy var nickNameTextField = UITextField().then {
        $0.delegate = self
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textAlignment = .center
        $0.borderStyle = .none
        $0.text = "닉네임"
    }

    private lazy var bottomLineView = UIView().then {
        $0.backgroundColor = .black
    }

    private lazy var clearButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle") ?? UIImage(), for: .normal)
    }

    private lazy var completeButton = BottomButton().then {
        $0.setTitle("확인", for: .normal)
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
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
    }

    func bind(_ viewModel: EditProfileViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        profileImageButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }

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

                picker.didFinishPicking { [unowned picker] items, _ in
                    if let photo = items.singlePhoto {
                        viewModel.changedImage.onNext(photo.image)
                    }
                    picker.dismiss(animated: true, completion: nil)
                }

                self.present(picker, animated: true, completion: nil)

            })
            .disposed(by: bag)

        nickNameTextField.rx.text.orEmpty
            .bind(to: viewModel.inputNickName)
            .disposed(by: bag)

        clearButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.nickNameTextField.text = ""
                viewModel.inputNickName.accept("")
            })
            .disposed(by: bag)

        completeButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.completeButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.profileImageURL
            .drive(profileImageButton.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nickNameTextField.rx.text)
            .disposed(by: bag)

        viewModel.setChangedImage
            .emit(to: profileImageButton.rx.image)
            .disposed(by: bag)

        viewModel.completeButtonValid
            .drive(completeButton.rx.isEnabled)
            .disposed(by: bag)

        viewModel.completeButtonActivity
            .drive(completeButton.rx.activityIndicator)
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushMainVC
            .emit(onNext: { [weak self] in
                let tapBarViewController = TabBarViewController()
                self?.navigationController?.pushViewController(tapBarViewController, animated: true, completion: {
                    Singleton.shred.toastAlert.onNext("회원가입이 완료되었습니다")
                })
            })
            .disposed(by: bag)

        viewModel.editComplete
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true, completion: {
                    Singleton.shred.toastAlert.onNext("프로필 편집이 완료되었습니다")
                })
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        addKeyboardNotification()
    }

    func layout() {
        [
            navigationView,
            setNickNameLabel,
            profileImageButton,
            nickNameTextField,
            bottomLineView,
            clearButton,
            completeButton,
        ].forEach {
            view.addSubview($0)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationView.viewHeight)
        }

        setNickNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(navigationView.snp.bottom).offset(45.0)
        }

        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(setNickNameLabel.snp.bottom).offset(54.0)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(view.frame.width * (100.0 / 390.0))
        }

        nickNameTextField.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(profileImageButton.snp.bottom).offset(36.0)
            $0.height.equalTo(32.0)
        }

        bottomLineView.snp.makeConstraints {
            $0.leading.trailing.equalTo(nickNameTextField)
            $0.top.equalTo(nickNameTextField.snp.bottom)
            $0.height.equalTo(1.0)
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

private extension EditProfileViewController {
    // 입력 시 키보드만큼 뷰 이동
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {}
    }

    @objc private func keyboardWillHide(_: Notification) {}

    // 주변 터치시 키보드 내림
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}

// MARK: TextField Delegate

extension EditProfileViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        guard let text = textField.text else { return true }
        return text.count <= 10
    }
}
