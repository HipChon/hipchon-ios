//
//  CategoryCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxSwift
import UIKit

class CategoryCell: UICollectionViewCell {
    public static let identyfier = "CategoryCell"
    private let bag = DisposeBag()

    private lazy var label = UILabel().then {
        $0.textAlignment = .center
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

    func bind(_ viewModel: CategoryCellViewModel) {
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
        let stackView = UIStackView(arrangedSubviews: [imageView, label])
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 8.0
        

        contentView.addSubview(stackView)

        imageView.snp.makeConstraints {
            $0.height.width.equalTo(45.0)
        }

        stackView.snp.makeConstraints {
            $0.width.equalTo(45.0)
            $0.centerX.centerY.equalToSuperview()
        }
    }
}
