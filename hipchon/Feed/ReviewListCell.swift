//
//  ReviewListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxSwift
import UIKit

class ReviewListCell: UITableViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .red
        $0.sizeToFit()
    }

    private lazy var contentLabel = UILabel().then {
        $0.textColor = .blue
        $0.sizeToFit()
    }

    private lazy var placeLabel = UILabel().then {
        $0.textColor = .green
        $0.sizeToFit()
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }

    func bind(_ viewModel: ReviewListCellViewModel) {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)

        viewModel.place
            .drive(placeLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.layer.cornerRadius = 12.0
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.backgroundColor = .white
        selectionStyle = .none
    }

    private func layout() {
        [
            titleLabel,
            contentLabel,
            placeLabel,

        ].forEach { contentView.addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }

        placeLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(50.0)
        }
    }
}
