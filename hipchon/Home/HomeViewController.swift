//
//  HomeViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import MaterialComponents.MaterialBottomSheet
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
        $0.setImage(UIImage(named: "search") ?? UIImage(), for: .normal)
    }

    private lazy var filterButton = UIButton().then {
        $0.setImage(UIImage(named: "filter") ?? UIImage(), for: .normal)
    }

    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = (view.frame.width - 32.0 * 2) / 4
        let height = width

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
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

    private lazy var marginView = UIView().then {
        $0.backgroundColor = .gray
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        attribute()
    }

    func bind(_ viewModel: HomeViewModel) {
        // MARK: subViews Binding

        pickView.bind(viewModel.pickViewModel)
        weelkyHipPlaceView.bind(viewModel.weeklyHipPlaceViewModel)

        // MARK: view -> viewModel

        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: bag)

        filterButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.filterButtonTapped)
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

        viewModel.pushPlaceListVC
            .emit(onNext: { [weak self] viewModel in
                let placeListVC = PlaceListViewController()
                placeListVC.bind(viewModel)
                self?.navigationController?.pushViewController(placeListVC, animated: false)
            })
            .disposed(by: bag)

        viewModel.presentFilterVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let filterVC = FilterViewController()
                filterVC.bind(viewModel)

                // MDC 바텀 시트로 설정
                let bottomSheet: MDCBottomSheetController = .init(contentViewController: filterVC)
                bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                                          height: filterVC.viewHeight)
                self.present(bottomSheet, animated: true, completion: nil)
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
            filterButton,
            categoryCollectionView,
            pickView,
            weelkyHipPlaceView,
            bannerCollectionView,
            marginView,
        ].forEach {
            contentView.addSubview($0)
        }

        mainLogoImageView.snp.makeConstraints {
            $0.width.equalToSuperview().multipliedBy(71.0 / 390.0)
            $0.height.equalTo(view.snp.width).multipliedBy(59.0 / 390.0)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(4.0)
//            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(4.0)
        }

        searchButton.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.centerY.equalTo(mainLogoImageView.snp.centerY)
//            $0.trailing.equalTo(filterButton.snp.leading).offset(24.0)
            $0.trailing.equalToSuperview().inset(27.0 + 16.0 + 24.0)
//            $0.trailing.equalTo(filterButton.snp.leading).offset(24.0)
        }

        filterButton.snp.makeConstraints {
            $0.height.width.equalTo(16.0)
            $0.top.equalTo(searchButton.snp.top)
            $0.trailing.equalToSuperview().inset(27.0)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(32.0)
            $0.top.equalTo(mainLogoImageView.snp.bottom).offset(29.0)
            let itemSize = (view.frame.width - 32.0 * 2) / 4
            $0.height.equalTo(itemSize * 2)
        }

        pickView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom).offset(16.0)
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

        marginView.snp.makeConstraints {
            $0.top.equalTo(bannerCollectionView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1000.0)
            $0.bottom.equalToSuperview()
        }
    }
}
