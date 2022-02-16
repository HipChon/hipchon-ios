//
//  PlaceListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import UIKit

class PlaceListCell: UITableViewCell {
    private lazy var placeImageCollectView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = contentView.frame.width
        let height = width * (166.0 / 350.0)

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(PhotoCell.self, forCellWithReuseIdentifier: PhotoCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18.0, weight: .bold)
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
        $0.textColor = .secondaryLabel
    }

    private lazy var categoryLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16.0, weight: .bold)
    }

    public static let identyfier = "PlaceListCell"
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
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 15.0, left: 20.0, bottom: 15.0, right: 20.0))
    }

    func bind(_ viewModel: PlaceListCellViewModel) {
        // MARK: viewModel -> view

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: bag)

        viewModel.category
            .drive(categoryLabel.rx.text)
            .disposed(by: bag)

        viewModel.placeImageURLs
            .drive(placeImageCollectView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withReuseIdentifier: PhotoCell.identyfier,
                                                        for: IndexPath(row: row, section: 0)) as? PhotoCell else { return UICollectionViewCell() }
                let viewModel = PhotoCellViewModel(data)
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.layer.cornerRadius = 12.0
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.backgroundColor = .white
        selectionStyle = .none
        clipsToBounds = true
    }

    private func layout() {
        [
            placeImageCollectView,
            nameLabel,
            addressLabel,
            categoryLabel,

        ].forEach { contentView.addSubview($0) }

        placeImageCollectView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(contentView.frame.width * (166.0 / 350.0))
        }

        nameLabel.snp.makeConstraints {
            $0.top.equalTo(placeImageCollectView.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().inset(22.0)
        }

        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(7.0)
            $0.leading.equalTo(nameLabel.snp.leading)
        }

        categoryLabel.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(14.0)
        }
    }
}
