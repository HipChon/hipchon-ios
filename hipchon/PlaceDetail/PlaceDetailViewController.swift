//
//  PlaceDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class PlaceDetailViewController: UIViewController {
    // MARK: Property
    private lazy var scrollView = UIScrollView().then { _ in
    }
    
    private lazy var contentView = UIView().then { _ in
        
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    private lazy var imageCollectView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = view.frame.width
          let height = width

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        $0.collectionViewLayout = layout
        
        $0.register(PlaceImageCell.self, forCellWithReuseIdentifier: PlaceImageCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }
    
    private lazy var marginView = UIView().then {
        $0.backgroundColor = .gray
    }
    
    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: PlaceDetailViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view
        viewModel.urls
            .drive(imageCollectView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: PlaceImageCell.identyfier, for: IndexPath(row: idx, section: 0)) as? PlaceImageCell else { return UICollectionViewCell() }
                let placeImageCellVM = PlaceImageCellViewModel(data)
                cell.bind(placeImageCellVM)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene
        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            backButton,
            imageCollectView,
            marginView
        ].forEach {
            contentView.addSubview($0)
        }
        
        backButton.snp.makeConstraints {
            $0.leading.top.equalToSuperview().offset(30.0)
            $0.height.width.equalTo(30.0)
        }
        
        imageCollectView.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(100.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        marginView.snp.makeConstraints {
            $0.top.equalTo(imageCollectView.snp.bottom).offset(100.0)
            $0.height.equalTo(1000.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        
    }
}