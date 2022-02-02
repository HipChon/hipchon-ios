//
//  HomeViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit
import Then

class HomeViewController: UIViewController {
    // MARK: Property

    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var searchBar = UISearchBar().then {
        $0.searchTextField.borderStyle = .none
    }

    private lazy var mainView = UIView().then {
        $0.backgroundColor = .red
    }

    private lazy var mainFilterView = MainFilterView().then { _ in
    }

    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10.0
        let width = (view.frame.width - 16.0 * 2 - 10.0 * 4) / 5
        let height = width

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        
        $0.collectionViewLayout = layout
        $0.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
    }

    private lazy var marginView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    private let bag = DisposeBag()
    let viewModel = HomeViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        attribute()
        layout()
    }

    func bind() {
        // MARK: subViews Binding

        mainFilterView.bind(viewModel.mainFilterViewModel)

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.cateogorys
            .drive(categoryCollectionView.rx.items) { col, idx, model in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identyfier, for: IndexPath(row: idx, section: 0)) as? CategoryCollectionViewCell else { return UICollectionViewCell() }
                cell.setDate(model)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene
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
            searchBar,
            mainFilterView,
            categoryCollectionView,
            marginView,
        ].forEach {
            contentView.addSubview($0)
        }

        searchBar.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(30.0)
            $0.height.equalTo(40.0)
        }

        mainFilterView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(24.0)
            $0.leading.trailing.equalToSuperview().inset(12.0)
            $0.height.equalTo(mainFilterView.snp.width).multipliedBy(0.8)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(mainFilterView.snp.bottom).offset(12.0)
            let itemSize = (view.frame.width - 16.0 * 2 - 10.0 * 4) / 5
            $0.height.equalTo(itemSize * 2 + 10.0)
        }

        marginView.snp.makeConstraints {
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(12.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1000.0)
            $0.bottom.equalToSuperview()
        }
    }
}
