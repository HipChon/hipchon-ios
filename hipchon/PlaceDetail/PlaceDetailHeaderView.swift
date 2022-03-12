//
//  PlaceDetailHeaderView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import Foundation
import UIKit
import RxSwift

class PlaceDetailHeaderView: UICollectionReusableView {
    
    
    private lazy var imageCollectView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = self.frame.width
        let height = width * (263.0 / 390.0)

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        $0.collectionViewLayout = layout

        $0.dataSource = nil
        $0.delegate = nil
        $0.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }
    
    private lazy var placeDesView = PlaceDesView().then { _ in
    }
    
    private lazy var firstBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }
    
    private lazy var secondBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }
    
    private lazy var placeMapView = PlaceMapView().then { _ in
    }
    
    private lazy var reviewComplimentListView = ReviewComplimentListView().then { _ in
    }
    
    public static let identyfier = "PlaceDetailHeaderView"
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageCollectView.delegate = nil
        imageCollectView.dataSource = nil
        attribute()
        layout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bind(_ viewModel: PlaceDetailHeaderViewModel) {
        // MARK: subViews Binding
        placeDesView.bind(viewModel.placeDesVM)
        placeMapView.bind(viewModel.placeMapVM)
        
        viewModel.reviewComplimentListVM
            .emit(onNext: { [weak self] in
                self?.reviewComplimentListView.bind($0)
            })
            .disposed(by: bag)

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.urls
            .drive(imageCollectView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageCell.identyfier, for: IndexPath(row: idx, section: 0)) as? ImageCell else { return UICollectionViewCell() }
                let placeImageCellVM = ImageCellViewModel(data)
                cell.bind(placeImageCellVM)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
    }
    
    private func layout() {
        // MARK: make constraints

        [
            
            imageCollectView,
            placeDesView,
            firstBorderView,
            placeMapView,
            secondBorderView,
            reviewComplimentListView
        ].forEach {
            addSubview($0)
        }
        
        imageCollectView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            $0.height.equalTo(self.frame.width * (263.0 / 390.0))
        }

        placeDesView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(imageCollectView.snp.bottom).offset(-15.0)
            $0.height.equalTo(444.0)
        }
        
        firstBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(placeDesView.snp.bottom)
            $0.height.equalTo(8.0)
        }
        
        placeMapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(firstBorderView.snp.bottom)
            $0.height.equalTo(285.0)
        }
        
        secondBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(placeMapView.snp.bottom)
            $0.height.equalTo(8.0)
        }
        
        reviewComplimentListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(secondBorderView.snp.bottom)
            $0.height.equalTo(275.0)
        }
    }
}
