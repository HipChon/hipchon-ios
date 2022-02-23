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

    private lazy var scrollView = UIScrollView().then { _ in
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }

    private lazy var placeNameLabel = UILabel().then {
        $0.text = "공간 이름"
        $0.font = .systemFont(ofSize: 24.0, weight: .medium)
    }

    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }

    private lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var dTLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
        $0.textColor = .secondaryLabel
    }

    private lazy var postDtLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }

    private lazy var reviewImageView = UIImageView().then {
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }

    private lazy var likeButton = UIButton().then {
        $0.setImage(UIImage(named: "like") ?? UIImage(), for: .normal)
    }

    private lazy var likeCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var commentButton = UIButton().then {
        $0.setImage(UIImage(named: "comment") ?? UIImage(), for: .normal)
    }

    private lazy var commentCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var messageButton = UIButton().then {
        $0.setImage(UIImage(named: "message") ?? UIImage(), for: .normal)
    }

    private lazy var messageCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmark") ?? UIImage(), for: .normal)
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.text = "0"
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
    }

    private lazy var linkView = UIView().then {
        $0.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        $0.layer.cornerRadius = 22.0
        $0.layer.masksToBounds = true
        $0.backgroundColor = .lightGray
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
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.profileImageURL
            .drive(profileImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.userName
            .drive(userNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.placeName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewImageURL
            .drive(reviewImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)

        // MARK: scene
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
            dTLabel,
            postDtLabel,
            reviewImageView,
            contentLabel,
            linkView,
        ].forEach { contentView.addSubview($0) }

        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(21.0)
            $0.leading.equalToSuperview().inset(28.0)
            $0.height.width.equalTo(15.0)
        }

        placeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(backButton.snp.bottom).offset(32.0)
        }

        profileImageView.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(36.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.height.width.equalTo(40.0)
        }

        userNameLabel.snp.makeConstraints {
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(39.0)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(11.0)
            $0.height.equalTo(15.0)
        }

        dTLabel.snp.makeConstraints {
            $0.top.equalTo(userNameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(userNameLabel)
            $0.height.equalTo(15.0)
        }

        postDtLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.height.equalTo(20.0)
        }

        reviewImageView.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(17.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(278.0)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(reviewImageView.snp.bottom).offset(45.0)
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
        ].forEach { contentView.addSubview($0) }

        likeButton.snp.makeConstraints {
            $0.top.equalTo(reviewImageView.snp.bottom).offset(13.0)
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
