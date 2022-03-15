//
//  MenuListView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/16.
//

import Foundation
import UIKit
import RxSwift

class MenuListView: UIView {
    
    private lazy var menuLabelImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewWhite") ?? UIImage()
    }
    
    private lazy var menuLabel = UILabel().then {
        $0.text = "메뉴"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }
    
    private lazy var menuCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 11.0
        let width = 170.0
        let height = 170.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(MenuCell.self, forCellWithReuseIdentifier: MenuCell.identyfier)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MenuListViewModel) {
        viewModel.menuCellVMs
            .drive(menuCollectionView.rx.items) { col, idx, viewModel in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: MenuCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? MenuCell else {
                    return UICollectionViewCell()
                }
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        [
            menuLabelImageView,
            menuLabel,
            menuCollectionView
        ].forEach {
            addSubview($0)
        }
        
        menuLabelImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(25.0)
        }
        
        menuLabel.snp.makeConstraints {
            $0.leading.equalTo(menuLabelImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(menuLabelImageView)
        }
        
        menuCollectionView.snp.makeConstraints {
            $0.top.equalTo(menuLabelImageView.snp.bottom).offset(22.0)
            $0.leading.trailing.equalToSuperview().inset(22.0)
            let height = 170.0
            $0.height.equalTo(height * 2 + 11)
            $0.bottom.equalToSuperview().inset(20.0)
        }
    }
}
