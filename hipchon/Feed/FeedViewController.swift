//
//  FeedViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class FeedViewController: UIViewController {
    // MARK: Property

    private let bag = DisposeBag()

    private lazy var searchNavigationView = SearchNavigationView().then { _ in
    }

    private lazy var reviewList = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReviewListCell.self, forCellReuseIdentifier: ReviewListCell.identyfier)
        $0.rowHeight = 440.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private lazy var uploadButton = UIButton().then {
        $0.setImage(UIImage(named: "upload"), for: .normal)
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
        // MARK: view -> viewModel

        reviewList.rx.modelSelected(ReviewModel.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedReview)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.reviews
            .drive(reviewList.rx.items) { tv, idx, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ReviewListCell.identyfier, for: IndexPath(row: idx, section: 0)) as? ReviewListCell else { return UITableViewCell() }
                let reviewListCellModel = ReviewListCellViewModel(data)
                cell.bind(reviewListCellModel)

                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushReviewDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let reviewDetailVC = ReviewDetailViewController()
                reviewDetailVC.bind(viewModel)
                self.navigationController?.pushViewController(reviewDetailVC, animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    private func layout() {
        [
            searchNavigationView,
            reviewList,
            uploadButton,
        ].forEach { view.addSubview($0) }

        searchNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }

        reviewList.snp.makeConstraints {
            $0.top.equalTo(searchNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        uploadButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26.0)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(43.0)
            $0.width.height.equalTo(50.0)
        }
    }
}
