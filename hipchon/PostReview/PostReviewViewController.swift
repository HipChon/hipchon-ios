//
//  ReviewPostViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift
import YPImagePicker

class PostReviewViewController: UIViewController {

    
    private lazy var navigationView = NavigationView().then { _ in
    }
    
    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }
    
    private lazy var placeImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }
    
    private lazy var placeNameLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
    }
    
    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }
    
    private lazy var keywordTitleLabel = UILabel().then {
        $0.text = "어떤 점이 좋았나요?"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }
    
    private lazy var keywordSubLabel = UILabel().then {
        $0.text = "어울리는 키워드를 골라주세요"
        $0.font = .GmarketSans(size: 16.0, type: .regular)
        $0.textColor = .gray04
    }

    private lazy var keywordListCollectionView = UICollectionView(frame: .zero,
                                                                 collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 16.0
        let width = 212.0
        let height = 286.0
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(KeywordListCell.self, forCellWithReuseIdentifier: KeywordListCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .white
    }
    
    private lazy var contentTitleLabel = UILabel().then {
        $0.text = "더 하고싶은 이야기"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }
    
    private lazy var contentSubLabel = UILabel().then {
        $0.text = "추가적으로 남기고 싶은 말들을 적어주세요"
        $0.font = .GmarketSans(size: 16.0, type: .regular)
        $0.textColor = .gray04
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.layer.borderColor = UIColor.gray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.isEditable = true
        $0.textContainerInset = UIEdgeInsets(top: 16.0, left: 8.0, bottom: 16.0, right: 8.0)
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
        $0.text = "내용을 입력하세요"
    }
    
    private lazy var contentCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.textColor = .gray04
        $0.text = "0 / 200"
    }
    
    private lazy var addPhotoButton = UIButton().then {
        $0.backgroundColor = .gray02
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.setTitle("사진 추가", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.setTitleColor(.gray05, for: .normal)
    }
    
    private lazy var completeButton = UIButton().then {
        $0.backgroundColor = .gray02
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.setTitle("완료", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .medium)
        $0.setTitleColor(.black, for: .normal)
    }
    
    private lazy var photoCollectView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 4.0
        let width = 173.0
        let height = 110.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
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
        config.library.maxNumberOfItems = 3 // 최대 사진 수
        
        config.wordings.libraryTitle = "갤러리"
        config.wordings.cameraTitle = "카메라"
        config.wordings.next = "다음"
        config.wordings.cancel = "취소"
        config.wordings.albumsTitle = "앨범"
        config.wordings.filter = "필터"
        config.wordings.done = "확인"
        config.wordings.warningMaxItemsLimit = "사진은 3장까지만 등록 가능합니다!"
        
        let picker = YPImagePicker(configuration: config)
        return picker
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let bag = DisposeBag()
    
    func bind(_ viewModel: PostReviewViewModel) {
        navigationView.bind(viewModel.navigtionVM)
        
        // MARK: view -> viewModel
        
        // MARK: view -> view
        
        contentTextView.rx.didBeginEditing
            .take(1)
            .bind(to: contentTextView.rx.firstEditing)
            .disposed(by: bag)
        
        addPhotoButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.present(self.picker, animated: true, completion: nil)
            })
            .disposed(by: bag)
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            var photos: [UIImage] = []
            for item in items {
                switch item {
                case .photo(let photo):
                    print("photo", photo)
                    photos.append(photo.image)
                case .video(let video):
                    print("video", video)
                }
            }
            viewModel.selectedPhotos.onNext(photos)
            picker.dismiss(animated: true, completion: nil)
        }
        
        // MARK: viewModel -> view
        
        viewModel.placeImageURL
            .drive(placeImageView.rx.setImageKF)
            .disposed(by: bag)
        
        viewModel.placeName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)
        
        let a = Driver.just(["", "", "", "", ""])
        
        a
            .drive(keywordListCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: KeywordListCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? KeywordListCell else {
                    return UICollectionViewCell()
                }
                let viewModel = KeywordListCellViewModel()
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)
        
        viewModel.photoCellVMs
            .drive(photoCollectView.rx.items) { col, idx, viewModel in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: PhotoCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? PhotoCell else {
                    return UICollectionViewCell()
                }
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        viewModel.photoCollectionViewHidden
            .map { $0 ? 0.0 : 110.0 }
            .drive(onNext: { height in
                self.photoCollectView.snp.makeConstraints {
                    $0.height.equalTo(height)
                }
            })
//            .drive(photoCollectView.rx.heightAnchor)
            .disposed(by: bag)
        
        // MARK: scene
        
        viewModel.pop
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    private func attribute() {
        hideKeyboardWhenTappedAround()
        view.backgroundColor = .white
    }
    
    private func layout() {
        
        [
            navigationView,
            scrollView
        ].forEach {
            view.addSubview($0)
        }
        
        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        
        [
            placeImageView,
            placeNameLabel,
            boundaryView,
            keywordTitleLabel,
            keywordSubLabel,
            keywordListCollectionView,
            contentTitleLabel,
            contentSubLabel,
            contentTextView,
            contentCountLabel,
            addPhotoButton,
            photoCollectView,
            completeButton
        ].forEach {
            contentView.addSubview($0)
        }
        
        placeImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(4.0)
            $0.width.height.equalTo(72.0)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeImageView)
            $0.leading.equalTo(placeImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(20.0)
        }
        
        boundaryView.snp.makeConstraints {
            $0.top.equalTo(placeImageView.snp.bottom).offset(23.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
        
        keywordTitleLabel.snp.makeConstraints {
            $0.top.equalTo(boundaryView.snp.bottom).offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        keywordSubLabel.snp.makeConstraints {
            $0.top.equalTo(keywordTitleLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        keywordListCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(keywordSubLabel.snp.bottom).offset(32.0)
            let height = 286.0
            $0.height.equalTo(height)
        }
        
        contentTitleLabel.snp.makeConstraints {
            $0.top.equalTo(keywordListCollectionView.snp.bottom).offset(32.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        contentSubLabel.snp.makeConstraints {
            $0.top.equalTo(contentTitleLabel.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        contentTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentSubLabel.snp.bottom).offset(28.0)
            $0.height.equalTo(106.0)
        }
        
        contentCountLabel.snp.makeConstraints {
            $0.trailing.equalTo(contentTextView)
            $0.top.equalTo(contentTextView.snp.bottom).offset(16.0)
        }
        
        addPhotoButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentTextView.snp.bottom).offset(12.0)
            $0.height.equalTo(42.0)
            $0.width.equalTo(108.0)
        }
        
        photoCollectView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(addPhotoButton.snp.bottom).offset(12.0)
        }
        
        completeButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(photoCollectView.snp.bottom).offset(48.0)
            $0.bottom.equalToSuperview().inset(78.0)
            $0.height.equalTo(51.0)
        }
        
    }
    
}

private extension PostReviewViewController {

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
//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//            keyboardHeight.onNext(keyboardSize.height + UITextField.keyboardUpBottomHeight)
//            navigationBottomHeight.onNext(16.0 - keyboardSize.height)
//        }
    }

    @objc private func keyboardWillHide(_: Notification) {
//        keyboardHeight.onNext(UITextField.keyboardDownBottomHeight)
//        navigationBottomHeight.onNext(16.0)
    }

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
