//
//  ReviewPostViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxCocoa
import RxSwift

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
        $0.font = .GmarketSans(size: 20.0, type: .medium)
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
    }
    
    private lazy var contentTitleLabel = UILabel().then {
        $0.text = "더 하고싶은 이야기"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }
    
    private lazy var contentSubLabel = UILabel().then {
        $0.text = "추가적으로 남기고 싶은 말들을 적어주세요"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
        $0.textColor = .gray04
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.layer.borderColor = UIColor.gray03.cgColor
        $0.layer.borderWidth = 1.0
        $0.isEditable = true
    }
    
    private lazy var addPhotoButton = UIButton().then {
        $0.backgroundColor = .gray02
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.setTitle("사진 추가", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        
    }
    
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
        
        
        viewModel.pop
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }
    
    private func attribute() {
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
            addPhotoButton
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
        
        addPhotoButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(contentTextView.snp.bottom).offset(12.0)
            $0.height.equalTo(42.0)
            $0.width.equalTo(108.0)
        }
        
        
    }
    
}
