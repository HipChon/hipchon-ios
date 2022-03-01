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
    
    private lazy var searchButton = SearchFilterButton().then {
        $0.setTitle("인원, 지역, 유형을 검색하세요", for: .normal)
        $0.setTitleColor(.secondaryLabel, for: .normal)
    }
    
    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .lightGray
    }


    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 20.0
        let width = (view.frame.width - 20.0 * 3) / 4
        let height = 106.0

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
    
    private lazy var kakaoTitleLabel = UILabel().then {
        $0.text = "어디서 살지 못 정하셨나요?"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var kakaoButton = UIButton().then {
        $0.backgroundColor = .systemYellow
        $0.setTitle("카카오톡 상담하기", for: .normal)
    }

    private lazy var supportLabel = UILabel().then {
        $0.text = "고객 지원"
        $0.font = .systemFont(ofSize: 16.0, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private lazy var placeRegisterButton = UIButton().then {
        $0.backgroundColor = .systemYellow
        $0.setTitle("공간 등록 문의", for: .normal)
    }

    private lazy var marginView = UIView().then {
        $0.backgroundColor = .white
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

        pickView.bind(viewModel.pickVM)
        bestReviewView.bind(viewModel.bestReviewVM)
        weelkyHipPlaceView.bind(viewModel.weeklyHipPlaceVM)

        // MARK: view -> viewModel

        searchButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: bag)
        
        categoryCollectionView.rx.modelSelected(CategoryModel.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedCategory)
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
            searchButton,
            boundaryView,
            categoryCollectionView,
            pickView,
            bestReviewView,
            bannerCollectionView,
            weelkyHipPlaceView,
            marginView,
        ].forEach {
            contentView.addSubview($0)
        }


        searchButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaInsets.top).offset(12.0)
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.height.equalTo(44.0)
        }
        
        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
            $0.top.equalTo(searchButton.snp.bottom).offset(16.0)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(boundaryView.snp.bottom)
            $0.height.equalTo(106.0)
        }

        pickView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.height.equalTo(394.0)
        }
        
        bestReviewView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(pickView.snp.bottom)
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
            $0.height.equalTo(237.0)
        }
        
        let stackView = UIStackView(arrangedSubviews: [kakaoTitleLabel, kakaoButton, supportLabel, placeRegisterButton])
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.backgroundColor = .white
        stackView.spacing = 20.0
        
        view.addSubview(stackView)
        
        [kakaoButton, placeRegisterButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(48.0)
            }
        }
        
        stackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(weelkyHipPlaceView.snp.bottom).offset(42.0)
        }
        
        
        marginView.snp.makeConstraints {
            $0.top.equalTo(stackView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1000.0)
            $0.bottom.equalToSuperview()
        }
        
    }
}
