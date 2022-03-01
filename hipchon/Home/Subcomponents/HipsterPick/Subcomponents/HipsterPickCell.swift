//
//  HipsterPickCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxSwift
import UIKit

class HipsterPickCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }

    public static let identyfier = "HipsterPickCell"
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

    func bind(_ viewModel: HipsterPickCellViewModel) {
        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
    }

    private func attribute() {
        layer.masksToBounds = true
        layer.cornerRadius = 2.0
    }

    private func layout() {
        [
            imageView,
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
