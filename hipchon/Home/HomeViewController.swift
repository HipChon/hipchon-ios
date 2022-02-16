//
//  HomeViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class HomeViewController: UIViewController {
    // MARK: Property

    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var mainLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "mainLogo") ?? UIImage()
    }

    private lazy var searchButton = UIButton().then {
        $0.setImage(UIImage(systemName: "magnifyingglass") ?? UIImage(), for: .normal)
    }

    private lazy var menuButton = UIButton().then {
        $0.setImage(UIImage(systemName: "line.3.horizontal") ?? UIImage(), for: .normal)
    }

    private lazy var searchBar = UISearchBar().then {
        $0.searchTextField.borderStyle = .none
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
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
    }

    private lazy var pickView = PickView().then { _ in
    }

    private lazy var weelkyHipPlaceView = WeeklyHipPlaceView().then { _ in
    }

    private lazy var bannerCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = view.frame.width
        let height = width * (218.0 / 390.0)

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(BannerCell.self, forCellWithReuseIdentifier: BannerCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }

    private lazy var mainFilterView = MainFilterView().then { _ in
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

    func bind(_ viewModel: HomeViewModel) {
        // MARK: subViews Binding

        mainFilterView.bind(viewModel.mainFilterViewModel)
        pickView.bind(viewModel.pickViewModel)
        weelkyHipPlaceView.bind(viewModel.weeklyHipPlaceViewModel)

        // MARK: view -> viewModel

        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: bag)

        menuButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.menuButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.cateogorys
            .drive(categoryCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: CategoryCell.identyfier, for: IndexPath(row: idx, section: 0)) as? CategoryCell else { return UICollectionViewCell() }
                let categoryCellViewModel = CategoryCellViewModel()
                cell.bind(categoryCellViewModel)
                categoryCellViewModel.category.accept(data)
                return cell
            }
            .disposed(by: bag)

        viewModel.banners
            .drive(bannerCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: BannerCell.identyfier, for: IndexPath(row: idx, section: 0)) as? BannerCell else { return UICollectionViewCell() }
                let bannerCellViewModel = BannerCellViewModel(data)
                cell.bind(bannerCellViewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushPlaceListViewController
            .emit(onNext: { [weak self] viewModel in
                let placeListViewController = PlaceListViewController()
                placeListViewController.bind(viewModel)
                self?.navigationController?.pushViewController(placeListViewController, animated: false)
            })
            .disposed(by: bag)
    }

    func attribute() {
        navigationController?.isNavigationBarHidden = true
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
            mainLogoImageView,
            searchButton,
            menuButton,
            searchBar,
            categoryCollectionView,
            pickView,
            weelkyHipPlaceView,
            bannerCollectionView,
//            mainFilterView,
            marginView,
        ].forEach {
            contentView.addSubview($0)
        }

        mainLogoImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(71.0 / 390.0)
            $0.height.equalTo(view.snp.width).multipliedBy(59.0 / 390.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(1.0)
        }

        searchButton.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.centerY.equalTo(mainLogoImageView.snp.centerY)
            $0.trailing.equalTo(menuButton.snp.leading).offset(24.0)
        }

        menuButton.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.top.equalTo(searchButton.snp.top)
            $0.trailing.equalToSuperview().inset(27.0)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(12.0)
            $0.width.equalToSuperview().multipliedBy(342.0 / 390.0)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(42.0)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchBar.snp.bottom).offset(12.0)
            let itemSize = (view.frame.width - 16.0 * 2 - 10.0 * 4) / 5
            $0.height.equalTo(itemSize * 2 + 10.0)
        }

        pickView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(20.0)
            $0.height.equalTo(331.0)
        }

        weelkyHipPlaceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(pickView.snp.bottom)
            $0.height.equalTo(157.0)
        }

        bannerCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(weelkyHipPlaceView.snp.bottom)
            let height = view.frame.width * (218.0 / 390.0)
            $0.height.equalTo(height)
        }

//        mainFilterView.snp.makeConstraints {
//            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(24.0)
//            $0.leading.trailing.equalToSuperview().inset(12.0)
//            $0.height.equalTo(mainFilterView.snp.width).multipliedBy(0.8)
//        }

        marginView.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1000.0)
            $0.bottom.equalToSuperview()
        }
    }
}
