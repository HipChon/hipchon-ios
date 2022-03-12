//
//  ReviewDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ReviewDetailViewController: UIViewController {
    // MARK: Property

    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
    }

    private lazy var placeNameLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
    }
    
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }

    private lazy var userNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .semibold)
    }

    private lazy var userReviewCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var postDateLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var reviewImageCollectionView = UICollectionView(frame: .zero,
                                                  collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 4.0
        let width = 300.0
        let height = 191.0
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 2.0
    }

    private lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
        
    }

    private lazy var likeCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
    }

    private lazy var commentButton = UIButton().then {
        $0.setImage(UIImage(named: "comment") ?? UIImage(), for: .normal)
    }

    private lazy var commentCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
        $0.numberOfLines = 0
    }

    private lazy var reviewPlaceView = ReviewPlaceView().then { _ in
    }
    
    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    
    private lazy var marginView = UIView().then { _ in
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
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    func bind(_ viewModel: ReviewDetailViewModel) {
        viewModel.reviewPlaceVM
            .drive(onNext: {
                self.reviewPlaceView.bind($0)
            })
            .disposed(by: bag)
        
        // MARK: viewModel -> view
        
        viewModel.placeName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.profileImageURL
            .drive(profileImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.userName
            .drive(userNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.userReviewCount
            .map { "\($0)번째 리뷰" }
            .drive(userReviewCountLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.postDate
            .drive(postDateLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewImageURLs
            .drive(reviewImageCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageCell.identyfier,
                                                        for: IndexPath(row: idx, section: 0)) as? ImageCell else { return UICollectionViewCell() }
                let viewModel = ImageCellViewModel(data)
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)
        
        viewModel.likeCount
            .map { "\($0)" }
            .drive(likeCountLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.commentCount
            .map { "\($0)" }
            .drive(commentCountLabel.rx.text)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
        
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        // MARK: scroll

        view.addSubview(scrollView)

        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }

        [
            backButton,
            placeNameLabel,
            profileImageView,
            userNameLabel,
            userReviewCountLabel,
            postDateLabel,
            reviewImageCollectionView,
            likeButton,
            likeCountLabel,
            commentButton,
            commentCountLabel,
            contentLabel,
            reviewPlaceView,
            boundaryView,
            marginView
        ].forEach {
            contentView.addSubview($0)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26.0)
            $0.top.equalTo(26.0)
            $0.width.height.equalTo(28.0)
        }
        
        placeNameLabel.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(20.0)
            $0.leading.equalToSuperview().inset(20.0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(40.0)
            $0.height.width.equalTo(45.0)
        }

        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(45.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            $0.height.equalTo(19.0)
        }

        userReviewCountLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(userNameLabel)
            $0.height.equalTo(16.0)
        }

        postDateLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.height.equalTo(17.0)
        }

        reviewImageCollectionView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(191.0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(reviewImageCollectionView.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }
        
        reviewPlaceView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(57.0)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(reviewPlaceView.snp.bottom).offset(32.0)
            $0.leading.equalToSuperview().inset(24.0)
            $0.width.height.equalTo(20.0)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton)
            $0.leading.equalTo(likeButton.snp.trailing).offset(12.0)
        }
        
        commentButton.snp.makeConstraints {
            $0.centerY.equalTo(likeCountLabel)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(12.0)
        }
        
        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(commentButton)
            $0.leading.equalTo(commentButton.snp.trailing).offset(12.0)
        }

        boundaryView.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(17.0)
            $0.leading.trailing.equalToSuperview().offset(20.0)
            $0.height.equalTo(1.0)
        }
        
        marginView.snp.makeConstraints {
            $0.height.equalTo(1000.0)
            $0.top.equalTo(boundaryView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
