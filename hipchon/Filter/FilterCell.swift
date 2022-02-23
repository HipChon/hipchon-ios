//
//  FilterCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/23.
//

import RxSwift
import UIKit

class FilterCell: UICollectionViewCell {
    lazy var filterLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14.0, weight: .regular)
        $0.textAlignment = .center
    }

    public static let identyfier = "FilterCell"
    let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: FilterCellViewModel) {
        viewModel.name
            .drive(filterLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.layer.cornerRadius = 16.5
        contentView.layer.masksToBounds = true
        contentView.layer.borderWidth = 1.0
        contentView.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func layout() {
        [
            filterLabel,
        ].forEach {
            contentView.addSubview($0)
        }

        filterLabel.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
