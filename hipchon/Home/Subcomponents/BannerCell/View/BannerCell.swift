//
//  BannerCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import RxSwift
import UIKit

class BannerCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    public static let identyfier = "BannerCell"
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

    func bind(_ viewModel: BannerCellViewModel) {
        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
    }

    private func attribute() {}

    private func layout() {
        [
            imageView,
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
