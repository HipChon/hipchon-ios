//
//  ImageURLCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation
import RxSwift
import UIKit

class ImageURLCell: UICollectionViewCell {
    public lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
    }

    public static let identyfier = "ImageURLCell"
    var bag = DisposeBag()

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
        bag = DisposeBag()
    }

    func bind(_ viewModel: ImageURLCellViewModel) {
        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
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
