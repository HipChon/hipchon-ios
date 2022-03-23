//
//  HashtagReviewViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift
import UIKit

class HashtagReviewViewController: UIViewController {
    // MARK: Property

    private let bag = DisposeBag()

    private lazy var reviewCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = view.frame.width / 2 - 16.0
        let height = (width - 8.0) * (185.0 / 171.0) + 4.0 * 2

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 12.0, left: 16.0, bottom: 0.0, right: 16.0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(HashtagReviewCell.self, forCellWithReuseIdentifier: HashtagReviewCell.identyfier)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = true
        $0.isPagingEnabled = false
        $0.backgroundColor = .white
    }

    private lazy var emptyView = EmptyView().then { _ in
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: HashtagReviewViewModel) {
        // MARK: subViews Binding

        reviewCollectionView.delegate = nil
        reviewCollectionView.dataSource = nil

        // MARK: view -> viewModel

        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewAppear)
            .disposed(by: bag)

        reviewCollectionView.rx.itemSelected
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .map { $0.row }
            .bind(to: viewModel.selectedReviewIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // refresh
        reviewCollectionView.refreshControl = UIRefreshControl()

        reviewCollectionView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.reload)
            .disposed(by: bag)

        viewModel.activating
            .distinctUntilChanged()
            .emit(to: reviewCollectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: bag)

        viewModel.reviewTableViewHidden
            .drive(reviewCollectionView.rx.isHidden)
            .disposed(by: bag)

        viewModel.reviewTableViewHidden
            .map { !$0 }
            .drive(emptyView.rx.isHidden)
            .disposed(by: bag)

        // more fetching

        reviewCollectionView.rx.contentOffset
            .map { [unowned self] in reviewCollectionView.isNearTheBottomEdge($0) }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.moreFetching)
            .disposed(by: bag)

        // data binding

        viewModel.profileReviewCellVMs
            .drive(reviewCollectionView.rx.items) { col, idx, viewModel in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: HashtagReviewCell.identyfier,
                                                         for: IndexPath(row: idx, section: 0)) as? HashtagReviewCell else { return UICollectionViewCell() }
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushReviewDetailVC
            .emit(onNext: { [weak self] viewModel in
                let reviewDetailVC = ReviewDetailViewController()
                reviewDetailVC.bind(viewModel)
                self?.tabBarController?.navigationController?.pushViewController(reviewDetailVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            reviewCollectionView,
            emptyView,
        ].forEach {
            view.addSubview($0)
        }

        reviewCollectionView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview() // .inset(20.0)
            let topInset = 18.0 + view.frame.width * (79.0 / 390.0) + 21.0 + 50.0 + 1.0
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topInset)
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(reviewCollectionView)
        }
    }
}
