//
//  PlaceDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then
import UIKit

class PlaceDetailViewController: UIViewController {
    // MARK: Property
    
    private lazy var scrollView = UIScrollView().then {
        $0.bounces = true
        $0.showsVerticalScrollIndicator = false
    }

    private lazy var contentView = UIView().then { _ in
    }

    private lazy var navigationView = UIView().then {
        $0.backgroundColor = .red
    }
    
    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: .normal)
    }
    
    private lazy var imageCollectView = UICollectionView(frame: .zero,
                                                         collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = UIApplication.shared.windows.first?.frame.width ?? 0.0
        let height = width * (263.0 / 390.0)

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        $0.collectionViewLayout = layout

        $0.dataSource = nil
        $0.delegate = nil
        $0.register(ImageURLCell.self, forCellWithReuseIdentifier: ImageURLCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true
    }

    private lazy var placeDesView = PlaceDesView().then { _ in
    }

    private lazy var firstBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var menuListView = MenuListView().then { _ in
    }

    private lazy var secondBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var placeMapView = PlaceMapView().then { _ in
    }

    private lazy var thirdBorderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var reviewKeywordListView = ReviewKeywordListView().then { _ in
    }

    private lazy var entireTableView = UITableView(frame: .zero).then {
        $0.backgroundColor = .white
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identyfier)
        $0.rowHeight = 393.0
        $0.showsVerticalScrollIndicator = false
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
    }

    private var bag = DisposeBag()
    var viewModel: PlaceDetailViewModel?

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
        self.viewModel = viewModel
        
        // MARK: subViewModels

        placeDesView.bind(viewModel.placeDesVM)
        placeMapView.bind(viewModel.placeMapVM)

        viewModel.menuListVM
            .emit(onNext: { [weak self] in
                self?.menuListView.bind($0)
            })
            .disposed(by: bag)

        viewModel.reviewKeywordListVM
            .emit(onNext: { [weak self] in
                self?.reviewKeywordListView.bind($0)
            })
            .disposed(by: bag)


        // MARK: view -> viewModel

        entireTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedReviewIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view
        
        viewModel.menuListViewHidden
            .drive(menuListView.rx.isHidden)
            .disposed(by: bag)

        viewModel.urls
            .drive(imageCollectView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: ImageURLCell.identyfier, for: IndexPath(row: idx, section: 0)) as? ImageURLCell else { return UICollectionViewCell() }
                let placeImageCellVM = ImageURLCellViewModel(data)
                cell.bind(placeImageCellVM)
                return cell
            }
            .disposed(by: bag)

        viewModel.reviewCellVms
            .drive(entireTableView.rx.items) { tv, _, viewModel in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ReviewCell.identyfier) as? ReviewCell else { return UITableViewCell() }
                cell.imageView?.contentMode = .scaleAspectFill
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:], completionHandler: nil)
            })
            .disposed(by: bag)

        viewModel.share
            .emit(onNext: { [weak self] in
                let activityVC = UIActivityViewController(activityItems: ["asd", "def"],
                                                          applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: bag)

        viewModel.pushReviewDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let reviewDetailVC = ReviewDetailViewController()
                reviewDetailVC.bind(viewModel)
                self.navigationController?.pushViewController(reviewDetailVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.pushPostReviewVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let postReviewVC = PostReviewViewController()
                postReviewVC.bind(viewModel)
                self.navigationController?.pushViewController(postReviewVC, animated: true)
            })
            .disposed(by: bag)

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
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)

        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        [
            
            placeDesView,
            firstBorderView,
            menuListView,
            secondBorderView,
            placeMapView,
            thirdBorderView,
            reviewKeywordListView,
            entireTableView,
            imageCollectView,
        ].forEach {
            contentView.addSubview($0)
        }
        view.addSubview(backButton)
        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(28.0)
            $0.width.height.equalTo(28.0)
        }

        imageCollectView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview()
            let width = UIApplication.shared.windows.first?.frame.width ?? 0.0
            let height = width * (263.0 / 390.0)
            $0.height.equalTo(height)
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

        menuListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(firstBorderView.snp.bottom)
        }

        secondBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(menuListView.snp.bottom)
            $0.height.equalTo(8.0)
        }

        placeMapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(secondBorderView.snp.bottom)
            $0.height.equalTo(285.0)
        }

        thirdBorderView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(placeMapView.snp.bottom)
            $0.height.equalTo(8.0)
        }

        reviewKeywordListView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(thirdBorderView.snp.bottom)
            $0.height.equalTo(275.0)
        }
    
        entireTableView.snp.makeConstraints {
            $0.top.equalTo(reviewKeywordListView.snp.bottom)
            $0.height.equalTo(393.0 * 3)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
