//
//  BestReviewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxSwift
import UIKit

class BestReviewCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private lazy var hashtagImageView = UIImageView().then { _ in
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
        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.hashtagImageURL
            .drive(hashtagImageView.rx.setImageKF)
            .disposed(by: bag)
    }

    private func attribute() {}

    private func layout() {
        [
            imageView,
            hashtagImageView,
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        hashtagImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(35.0)
            $0.top.equalToSuperview().offset(6.0)
            $0.height.equalTo(76.0)
            $0.width.equalTo(58.0)
        }
    }
}
