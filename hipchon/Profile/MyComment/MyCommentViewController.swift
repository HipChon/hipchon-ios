//
//  MyCommentViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxCocoa
import RxSwift
import UIKit

class MyCommentViewController: UIViewController {
    // MARK: Property

    private lazy var myCommentTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(MyCommentCell.self, forCellReuseIdentifier: MyCommentCell.identyfier)
        $0.rowHeight = 106.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private lazy var emptyView = AuthorizedEmptyView().then { _ in
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

    func bind(_ viewModel: MyCommentViewModel) {
        // MARK: subViews Binding

        myCommentTableView.delegate = nil
        myCommentTableView.dataSource = nil

        // MARK: view -> viewModel
        
        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewAppear)
            .disposed(by: bag)

        myCommentTableView.rx.itemSelected
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .map { $0.row }
            .bind(to: viewModel.selectedCommentIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // refresh
        myCommentTableView.refreshControl = UIRefreshControl()

        myCommentTableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.reload)
            .disposed(by: bag)

        viewModel.activating
            .distinctUntilChanged()
            .emit(to: myCommentTableView.refreshControl!.rx.isRefreshing)
            .disposed(by: bag)

        // more fetching

        myCommentTableView.rx.contentOffset
            .map { [unowned self] in myCommentTableView.isNearTheBottomEdge($0) }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.moreFetching)
            .disposed(by: bag)

        viewModel.commentTableViewHidden
            .drive(myCommentTableView.rx.isHidden)
            .disposed(by: bag)

        viewModel.commentTableViewHidden
            .map { !$0 }
            .drive(emptyView.rx.isHidden)
            .disposed(by: bag)

        // data binding

        viewModel.myCommentCellVMs
            .drive(myCommentTableView.rx.items) { tv, idx, viewModel in
                guard let cell = tv.dequeueReusableCell(withIdentifier: MyCommentCell.identyfier,
                                                        for: IndexPath(row: idx, section: 0)) as? MyCommentCell else { return UITableViewCell() }
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
            myCommentTableView,
            emptyView,
        ].forEach {
            view.addSubview($0)
        }

        myCommentTableView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview() // .inset(20.0)
            let topInset = 18.0 + view.frame.width * (79.0 / 390.0) + 21.0 + 50.0 + 1.0
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(topInset)
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(myCommentTableView)
        }
    }
}
