//
//  ReviewDetailHeaderView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/30.
//

import RxSwift
import UIKit

class ReviewDetailHeaderView: UITableViewHeaderFooterView {
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
        $0.delegate = nil
        $0.dataSource = nil

        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 4.0
        let width = 300.0
        let height = 191.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 20.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(ImageURLCell.self, forCellWithReuseIdentifier: ImageURLCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 2.0
        $0.backgroundColor = .white
    }

    private lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal) // Todo
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

    private lazy var reportButton = UIButton().then {
        $0.setImage(UIImage(named: "report"), for: .normal)
        $0.setTitle(" 신고하기", for: .normal)
        $0.setTitleColor(.gray04, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
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

    public static let identyfier = "ReviewDetailHeaderView"
    private var bag = DisposeBag()
    var viewModel: ReviewDetailHeaderViewModel?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = 45.0 / 2 // profileImageView.frame.width / 2

        viewModel?.reviewImageURLs
            .map { $0.count }
            .asDriver()
            .drive(onNext: { [unowned self] count in
                let cellWidth = self.contentView.frame.width
                if let layout = self.reviewImageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
                    var width = 300.0
                    let height = 191.0
                    let itemSpacing = 4.0
                    switch count {
                    case 1:
                        width = cellWidth - 20.0 * 2
                    case 2:
                        width = (cellWidth - 20.0 * 2 - itemSpacing) / 2
                    default:
                        break
                    }

                    layout.itemSize = CGSize(width: width, height: height)
                    layout.minimumLineSpacing = itemSpacing
                    layout.minimumInteritemSpacing = itemSpacing
                }
            })
            .disposed(by: bag)
    }


    func bind(_ viewModel: ReviewDetailHeaderViewModel) {
        // MARK: subViewModels
        
        self.viewModel = viewModel

        viewModel.reviewPlaceVM
            .drive(onNext: {
                self.reviewPlaceView.bind($0)
            })
            .disposed(by: bag)

        // MARK: view -> viewModel

        likeButton.rx.tap
            .bind(to: viewModel.likeButtonTapped)
            .disposed(by: bag)

        reportButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.reportButtonTapped)
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
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageURLCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? ImageURLCell else { return UICollectionViewCell() }
                let viewModel = ImageURLCellViewModel(data)
                cell.imageView.contentMode = .scaleAspectFill
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        viewModel.likeYn
            .compactMap { $0 ? UIImage(named: "likeY") : UIImage(named: "likeN") }
            .drive(likeButton.rx.image)
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

        viewModel.pushPlaceDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let topVC = UIApplication.topViewController() else { return }
                let placeDetailVC = PlaceDetailViewController()
                placeDetailVC.bind(viewModel)
                topVC.navigationController?.pushViewController(placeDetailVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.share
            .emit(onNext: { [weak self] in
                guard let topVC = UIApplication.topViewController() else { return }
                let activityVC = UIActivityViewController(activityItems: [$0],
                                                          applicationActivities: nil)
                topVC.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        profileImageView.layer.cornerRadius = 22.5
    }

    private func layout() {
        [
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
            reportButton,
            contentLabel,
            reviewPlaceView,
            boundaryView,
        ].forEach {
            addSubview($0)
        }

        placeNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(7.0)
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

        reportButton.snp.makeConstraints {
            $0.centerY.equalTo(commentButton)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        boundaryView.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom).offset(17.0)
            $0.leading.trailing.equalToSuperview().offset(20.0)
            $0.height.equalTo(1.0)
            $0.bottom.equalToSuperview().inset(0.0)
        }
    }
}
