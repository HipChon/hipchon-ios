//
//  ReviewListViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/22.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ReviewListViewController: UIViewController {
    // MARK: Property

    private lazy var navigationView = NavigationView().then { _ in
    }

    private lazy var postReviewButton = UIButton().then {
        $0.setImage(UIImage(named: "postReview") ?? UIImage(), for: .normal)
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
    }

    private lazy var reviewTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identyfier)
        $0.rowHeight = 309.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private let bag = DisposeBag()
    var viewModel: ReviewListViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        attribute()
    }

    func bind(_ viewModel: ReviewListViewModel) {
        // MARK: subviewModels

        self.viewModel = viewModel

        // MARK: view -> viewModel

        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewAppear)
            .disposed(by: bag)

        reviewTableView.rx.itemSelected
            .map { $0.row }
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedReviewIdx)
            .disposed(by: bag)

        postReviewButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.postReviewButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // refresh
        reviewTableView.refreshControl = UIRefreshControl()

        reviewTableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.reload)
            .disposed(by: bag)

        viewModel.activating
            .distinctUntilChanged()
            .emit(to: reviewTableView.refreshControl!.rx.isRefreshing)
            .disposed(by: bag)

        viewModel.reviewCount
            .map { "\($0)개의 리뷰" }
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)

        // more fetching

        reviewTableView.rx.contentOffset
            .map { [unowned self] in reviewTableView.isNearTheBottomEdge($0) }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.moreFetching)
            .disposed(by: bag)

        // data binding

        viewModel.reviewCellVMs
            .drive(reviewTableView.rx.items) { tv, idx, viewModel in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ReviewCell.identyfier,
                                                        for: IndexPath(row: idx, section: 0)) as? ReviewCell else { return UITableViewCell() }
                cell.reviewPlaceView.isHidden = true
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

        viewModel.pushPostReviewVC
            .emit(onNext: { [weak self] viewModel in
                let postReviewVC = PostReviewViewController()
                postReviewVC.bind(viewModel)
                self?.navigationController?.pushViewController(postReviewVC, animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    private func layout() {
        [
            navigationView,
            postReviewButton,
            boundaryView,
            reviewCountLabel,
            reviewTableView,
        ].forEach { view.addSubview($0) }

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationView.viewHeight)
        }

        postReviewButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(21.0)
            $0.centerY.equalTo(navigationView)
            $0.width.height.equalTo(28.0)
        }

        boundaryView.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }

        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(boundaryView.snp.top).offset(24.0)
            $0.height.equalTo(24.0)
        }

        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(reviewCountLabel.snp.bottom).offset(14.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
