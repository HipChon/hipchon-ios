//
//  WeeklyHipPlaceView.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class WeeklyHipPlaceView: UIView {
    private let bag = DisposeBag()

    private lazy var titleLabel = UILabel().then {
        $0.text = "주간 힙플"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }

    private lazy var hipPlaceCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10.0

        let width = 296.0
        let height = 154.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 30.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(HipPlaceCell.self, forCellWithReuseIdentifier: HipPlaceCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = false
        $0.backgroundColor = .white
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

    func bind(_ viewModel: WeeklyHipPlaceViewModel) {
        // MARK: view -> viewModel

        hipPlaceCollectionView.rx.itemSelected
            .map { $0.row }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.hipPlaces
            .drive(hipPlaceCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: HipPlaceCell.identyfier, for: IndexPath(row: idx, section: 0)) as? HipPlaceCell else { return UICollectionViewCell() }
                let vm = HipPlaceCellViewModel(data)
                cell.bind(vm)
                return cell
            }
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            titleLabel,
            hipPlaceCollectionView,
        ].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.top.equalToSuperview().inset(20.0)
        }

        hipPlaceCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.bottom.equalToSuperview().inset(20.0)
//            $0.height.equalTo(154.0)
        }
    }
}
