//
//  BestReviewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxSwift
import UIKit

class BestReviewCell: UICollectionViewCell {
    private lazy var titleLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .semibold)
        $0.textColor = .black
        $0.numberOfLines = 2
    }

    private lazy var hashtagImageView = UIImageView().then {
        $0.image = UIImage(named: "물멍")
    }

    public static let identyfier = "BestReviewCell"
    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: BestReviewCellViewModel) {
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)

//        viewModel.hashtagImageURL
//            .drive(hashtagImageView.rx.setImageKF)
//            .disposed(by: bag)
    }

    private func attribute() {
        let colors = [
            UIColor.primary_green,
            UIColor.secondary_red,
            UIColor.secondary_blue,
            UIColor.secondary_purple,
            UIColor.secondary_yellow,
        ]
        backgroundColor = colors[Int.random(in: 0 ... 4)]
        self.layer.masksToBounds = false
    }

    private func layout() {
        [
            titleLabel,
            hashtagImageView,
        ].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(24.0)
            $0.trailing.equalTo(hashtagImageView.snp.leading).offset(20.0).priority(.low)
        }

        hashtagImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35.0)
            $0.top.equalToSuperview().offset(8.0)
            $0.height.equalTo(56.0)
            $0.width.equalTo(38.0).priority(.high)
        }
    }
}
