//
//  FeedViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import MaterialComponents.MaterialBottomSheet
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class FeedViewController: UIViewController {
    // MARK: Property

    private let bag = DisposeBag()

    private lazy var reviewLabel = UILabel().then {
        $0.text = "후기"
        $0.font = .GmarketSans(size: 24.0, type: .medium)
    }

    private lazy var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "sort") ?? UIImage(), for: .normal)
        $0.isHidden = true // TODO: delete
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    private lazy var reviewTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identyfier)
        $0.rowHeight = 393.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private lazy var emptyView = UnathorizedEnptyView().then { _ in
    }

    private lazy var uploadButton = UIButton().then {
        $0.setImage(UIImage(named: "upload"), for: .normal)
        $0.isHidden = true // TODO: delete
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

    override func viewDidLayoutSubviews() {
        attribute()
    }

    func bind(_ viewModel: FeedViewModel) {
        // MARK: subviewModels

        // MARK: view -> viewModel

        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewAppear)
            .disposed(by: bag)

        reviewTableView.rx.itemSelected
            .map { $0.row }
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedReviewIdx)
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

        viewModel.reviewTableViewHidden
            .drive(reviewTableView.rx.isHidden)
            .disposed(by: bag)

        viewModel.reviewTableViewHidden
            .map { !$0 }
            .drive(emptyView.rx.isHidden)
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

        viewModel.reviews
            .drive(reviewTableView.rx.items) { tv, idx, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ReviewCell.identyfier,
                                                        for: IndexPath(row: idx, section: 0)) as? ReviewCell else { return UITableViewCell() }
                let viewModel = ReviewCellViewModel(data)
                cell.bind(viewModel)

//                viewModel.pushPlaceDetailVC
//                    .emit(onNext: { [weak self] viewModel in
//                        let placeDetailVC = PlaceDetailViewController()
//                        placeDetailVC.bind(viewModel)
//                        self?.tabBarController?.navigationController?.pushViewController(placeDetailVC, animated: true)
//                    })
//                    .disposed(by: cell.bag)

                viewModel.share
                    .emit(onNext: { [weak self] in
                        let activityVC = UIActivityViewController(activityItems: [$0],
                                                                  applicationActivities: nil)
                        self?.present(activityVC, animated: true, completion: nil)
                    })
                    .disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushReviewDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let reviewDetailVC = ReviewDetailViewController()
                reviewDetailVC.bind(viewModel)
                self.tabBarController?.navigationController?.pushViewController(reviewDetailVC, animated: true)
            })
            .disposed(by: bag)

//        viewModel.presentFilterVC
//            .emit(onNext: { [weak self] viewModel in
//                guard let self = self else { return }
//                let filterVC = FilterViewController()
//                filterVC.bind(viewModel)
//
//                // MDC 바텀 시트로 설정
//                let bottomSheet: MDCBottomSheetController = .init(contentViewController: filterVC)
//                bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width,
//                                                          height: filterVC.viewHeight)
//                self.present(bottomSheet, animated: true, completion: nil)
//            })
//            .disposed(by: bag)
    }

    private func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    private func layout() {
        [
            reviewLabel,
            sortButton,
            boundaryView,
            reviewTableView,
            emptyView,
            uploadButton,
        ].forEach { view.addSubview($0) }

        reviewLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(18.0)
            $0.height.equalTo(24.0)
        }

        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26.0)
            $0.centerY.equalTo(reviewLabel)
            $0.width.height.equalTo(15.0)
        }

        boundaryView.snp.makeConstraints {
            $0.top.equalTo(reviewLabel.snp.bottom).offset(30.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }

        reviewTableView.snp.makeConstraints {
            $0.top.equalTo(boundaryView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(reviewTableView)
        }

        uploadButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(43.0)
            $0.width.height.equalTo(50.0)
        }
    }
}
