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
    
    private lazy var homeSearchView = HomeSearchView().then { _ in
    }


    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10.0
        let width = (view.frame.width - itemSpacing * 3) / 4
        let height = 106.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(CategoryCell.self, forCellWithReuseIdentifier: CategoryCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .white
    }

    private lazy var hipsterPickView = HipsterPickView().then { _ in
    }
    
    private lazy var bestReviewView = BestReviewView().then { _ in
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
    
    private lazy var weelkyHipPlaceView = WeeklyHipPlaceView().then { _ in
    }
    
    private lazy var customerServiceView = CustomerServiewView().then { _ in
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

        homeSearchView.bind(viewModel.homeSearchVM)
        hipsterPickView.bind(viewModel.hipsterPickVM)
        bestReviewView.bind(viewModel.bestReviewVM)
        weelkyHipPlaceView.bind(viewModel.weeklyHipPlaceVM)
        customerServiceView.bind(viewModel.customerServiceVM)

        // MARK: view -> viewModel
        
        categoryCollectionView.rx.modelSelected(CategoryModel.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedCategory)
            .disposed(by: bag)
        
        bannerCollectionView.rx.modelSelected(BannerModel.self)
            .bind(to: viewModel.selectedBanner)
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
                self?.tabBarController?.navigationController?.pushViewController(placeListVC, animated: true)
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
        
        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:])
            })
            .disposed(by: bag)
        
//        viewModel.pushPlaceDetailVC
//            .emit(onNext: { [weak self] viewModel in
//                let placeDetailVC = PlaceDetailViewController()
//                placeDetailVC.bind(viewModel)
//                self?.tabBarController?.navigationController?.pushViewController(placeDetailVC, animated: true)
//            })
//            .disposed(by: bag)
        
        viewModel.pushHipsterPickDetailVC
            .emit(onNext: { [weak self] viewModel in
                let hipsterPickDetailVC = HipsterPickDetailViewController()
                hipsterPickDetailVC.bind(viewModel)
                self?.tabBarController?.navigationController?.pushViewController(hipsterPickDetailVC, animated: true)
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
            homeSearchView,
            categoryCollectionView,
            hipsterPickView,
            bestReviewView,
            bannerCollectionView,
            weelkyHipPlaceView,
            customerServiceView
        ].forEach {
            contentView.addSubview($0)
        }

        homeSearchView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(74.0)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(homeSearchView.snp.bottom)
            $0.height.equalTo(106.0)
        }

        hipsterPickView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.height.equalTo(394.0)
        }
        
        bestReviewView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(hipsterPickView.snp.bottom)
            $0.height.equalTo(162.0)
        }
        
        bannerCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bestReviewView.snp.bottom)
            let height = view.frame.width * (137.0 / 390.0)
            $0.height.equalTo(height)
        }

        weelkyHipPlaceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bannerCollectionView.snp.bottom)
            $0.height.equalTo(229.0)
        }
        
        customerServiceView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(weelkyHipPlaceView.snp.bottom)
            $0.height.equalTo(231.0)
            $0.bottom.equalToSuperview()
        }
    }
}
