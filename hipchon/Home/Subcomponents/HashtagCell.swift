//
//  HashtagCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxSwift
import UIKit

class HashtagCell: UICollectionViewCell {
    public static let identyfier = "HashtagCell"
    private let bag = DisposeBag()

    private lazy var label = UILabel().then {
        $0.textAlignment = .center
        $0.font = .GmarketSans(size: 14.0, type: .medium)
    }

    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: HashtagCellViewModel) {
        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.title
            .drive(label.rx.text)
            .disposed(by: bag)

        viewModel.image
            .drive(imageView.rx.image)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.backgroundColor = .white
    }

    private func layout() {
        [
            imageView,
            label,
        ].forEach {
            addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(45.0)
        }

        label.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(imageView.snp.bottom).offset(8.0)
        }
    }
}
