//
//  CommectCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import Foundation
import RxSwift
import UIKit

class CommentCell: UITableViewCell {
    private lazy var profileImageView = UIImageView().then {
        $0.layer.masksToBounds = true
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .black
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.numberOfLines = 0
    }

    private lazy var timeForNowLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 13.0, type: .regular)
        $0.textColor = .gray04
    }
    
    private lazy var reportButton = UIButton().then {
        $0.setImage(UIImage(named: "report"), for: .normal)
        $0.setTitle(" 신고하기", for: .normal)
        $0.setTitleColor(.gray04, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 13.0, type: .regular)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    public static let identyfier = "CommentCell"
    private var bag = DisposeBag()
    var viewModel: CommentCellViewModel?

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
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }

    func bind(_ viewModel: CommentCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.profileImageURL
            .drive(profileImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)

        viewModel.timeForNow
            .drive(timeForNowLabel.rx.text)
            .disposed(by: bag)
        
        // TODO: change
        reportButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.reportButtonTapped)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        selectionStyle = .none
    }

    private func layout() {
        [
            profileImageView,
            nameLabel,
            contentLabel,
            timeForNowLabel,
            reportButton
        ].forEach {
            addSubview($0)
        }

        profileImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(12.0)
            $0.width.height.equalTo(45.0)
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8.0)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(17.0)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5.0)
            $0.leading.equalTo(nameLabel)
            $0.trailing.equalToSuperview().inset(16.0)
        }

        timeForNowLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(10.0)
            $0.leading.equalTo(nameLabel)
            $0.bottom.equalToSuperview().inset(12.0)
        }
        
        reportButton.snp.makeConstraints {
            $0.leading.equalTo(timeForNowLabel.snp.trailing).offset(16.0)
            $0.centerY.equalTo(timeForNowLabel)
            $0.height.equalTo(20.0)
        }
    }
}
