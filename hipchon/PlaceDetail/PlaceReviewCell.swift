//
//  PlaceReviewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxSwift
import UIKit

class PlaceReviewCell: UICollectionViewCell {
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }

    private lazy var userNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.textColor = .secondaryLabel
    }

    private lazy var postDtLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
    }

    private lazy var imageCollectView = UICollectionView(frame: .zero,
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
        $0.register(ImageURLCell.self, forCellWithReuseIdentifier: ImageURLCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }
    

    private lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var likeCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var commentButton = UIButton().then {
        $0.setImage(UIImage(named: "comment") ?? UIImage(), for: .normal)
    }

    private lazy var commentCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var messageButton = UIButton().then {
        $0.setImage(UIImage(named: "share") ?? UIImage(), for: .normal)
    }

    private lazy var messageCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmark") ?? UIImage(), for: .normal)
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var linkView = UIView().then {
        $0.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        $0.layer.cornerRadius = 22.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
    }

    public static let identyfier = "PlaceReviewCell"
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("CELL REUSE")
//        bag = DisposeBag()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    func bind(_ viewModel: PlaceReviewCellViewModel) {
        // MARK: viewModel -> view

        viewModel.profileImageURL
            .drive(profileImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.userName
            .drive(userNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewCount
            .map { "리뷰 수 \($0)"}
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.postDt
            .drive(postDtLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewImageURLs
            .drive(imageCollectView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageURLCell.identyfier, for: IndexPath(row: idx, section: 0)) as? ImageURLCell else { return UICollectionViewCell() }
                let imageCellVM = ImageURLCellViewModel(data)
                cell.bind(imageCellVM)
                return cell
            }
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            profileImageView,
            userNameLabel,
            reviewCountLabel,
            postDtLabel,
            imageCollectView,
            contentLabel,
            linkView,
        ].forEach { contentView.addSubview($0) }

        profileImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20.0)
            $0.height.width.equalTo(40.0)
        }

        userNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(23.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11.0)
            $0.height.equalTo(15.0)
        }

        reviewCountLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(userNameLabel)
            $0.height.equalTo(15.0)
        }

        postDtLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(reviewCountLabel.snp.centerY)
            $0.height.equalTo(17.0)
        }

        imageCollectView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(17.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(110.0)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectView.snp.bottom).offset(45.0)
            $0.leading.equalToSuperview().inset(30.0)
        }

        linkView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(5.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(44.0)
        }

        // MARK: Buttons

        [
            likeButton,
            likeCountLabel,
            commentButton,
            commentCountLabel,
            messageButton,
            messageCountLabel,
            bookmarkButton,
            bookmarkCountLabel,
        ].forEach { addSubview($0) }

        likeButton.snp.makeConstraints {
            $0.top.equalTo(imageCollectView.snp.bottom).offset(13.0)
            $0.leading.equalToSuperview().inset(30.0)
            $0.width.height.equalTo(20.0)
        }

        likeCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(likeButton.snp.trailing).offset(8.0)
            $0.width.equalTo(24.0)
        }

        commentButton.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(likeCountLabel.snp.trailing).offset(8.0)
            $0.width.height.equalTo(20.0)
        }

        commentCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(commentButton.snp.trailing).offset(8.0)
            $0.width.equalTo(24.0)
        }

        messageButton.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(commentCountLabel.snp.trailing).offset(8.0)
            $0.width.height.equalTo(20.0)
        }

        messageCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.leading.equalTo(messageButton.snp.trailing).offset(8.0)
            $0.width.equalTo(24.0)
        }

        bookmarkButton.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
//            $0.trailing.equalTo(bookmarkCountLabel.snp.leading).offset(8.0)
            $0.trailing.equalToSuperview().inset(20.0 + 24.0 + 8.0)
            $0.width.height.equalTo(20.0)
        }

        bookmarkCountLabel.snp.makeConstraints {
            $0.centerY.equalTo(likeButton.snp.centerY)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.equalTo(24.0)
        }
    }
}
