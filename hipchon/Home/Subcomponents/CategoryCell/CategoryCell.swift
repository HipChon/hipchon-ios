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

    private lazy var label = UILabel().then { _ in
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
        [
            imageView,
            label,
        ].forEach {
            contentView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
        }
    }

    func setDate(_ data: CategoryModel) {
        label.text = data.name
    }
}
