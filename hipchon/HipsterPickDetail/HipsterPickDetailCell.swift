//
//  HipsterPickDetailCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/14.
//

import RxSwift
import UIKit

class HipsterPickDetailCell: UITableViewCell {
    private lazy var imageCollectView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = UIApplication.shared.windows.first?.frame.width ?? 0.0
        let height = width * (238.0 / 390.0)

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        $0.collectionViewLayout = layout
        $0.backgroundColor = .white
        $0.register(ImageURLCell.self, forCellWithReuseIdentifier: ImageURLCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 18.0, type: .semibold)
    }

    private lazy var contentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.numberOfLines = 0
    }

    private lazy var reviewPlace = ReviewPlaceView().then { _ in
    }

    public static let identyfier = "HipsterPickDetailCell"
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

    func bind(_ viewModel: HipsterPickDetailCellViewModel) {
        // MARK: subViewModels

        viewModel.reviewPlaceVM
            .drive(onNext: { [weak self] in
                self?.reviewPlace.bind($0)
            })
            .disposed(by: bag)

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.imageURLs
            .drive(imageCollectView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageURLCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? ImageURLCell else { return UICollectionViewCell() }
                let viewModel = ImageURLCellViewModel(data)
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)

        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        selectionStyle = .none
    }

    private func layout() {
        [
            imageCollectView,
            titleLabel,
            contentLabel,
            reviewPlace,
        ].forEach {
            addSubview($0)
        }

        imageCollectView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22.0)
            $0.leading.trailing.equalToSuperview()
            let width = UIApplication.shared.windows.first?.frame.width ?? 0.0
            let height = width * (238.0 / 390.0)
            $0.height.equalTo(height)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(imageCollectView.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview().offset(20.0)
        }

        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }

        reviewPlace.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(20.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(57.0)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}
