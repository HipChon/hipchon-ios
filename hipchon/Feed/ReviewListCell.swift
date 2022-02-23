//
//  ReviewListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxSwift
import UIKit

class ReviewListCell: UITableViewCell {
    private lazy var profileImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.masksToBounds = true
    }

    private lazy var userNameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14.0, weight: .regular)
    }

    private lazy var placeNameLabel = UILabel().then {
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

    public static let identyfier = "ReviewListCell"
    private let bag = DisposeBag()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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

    func bind(_ viewModel: ReviewListCellViewModel) {
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
    }

    private func attribute() {
        selectionStyle = .none
    }

    private func layout() {
        [
            profileImageView,
            userNameLabel,
            placeNameLabel,
            postDtLabel,
            reviewImageView,
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

        placeNameLabel.snp.makeConstraints {
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
            $0.height.equalTo(211.0)
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
        ].forEach { addSubview($0) }

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
