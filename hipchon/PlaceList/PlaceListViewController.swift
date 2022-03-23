//
//  PlaceListViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import MaterialComponents.MaterialBottomSheet
import RxSwift
import UIKit

class PlaceListViewController: UIViewController {
    private lazy var searchNavigationView = SearchNavigationView().then { _ in
    }

    private lazy var placeTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identyfier)
        $0.rowHeight = (view.frame.width - 40.0) * ((255.0 + 16.0) / 351.0)
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private lazy var emptyView = EmptyView().then { _ in
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

    func bind(_ viewModel: PlaceListViewModel) {
        // MARK: subviewModels

        placeTableView.delegate = nil
        placeTableView.dataSource = nil
        searchNavigationView.bind(viewModel.searchNavigationVM)

        // MARK: view -> viewModel

        placeTableView.rx.itemSelected
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .map { $0.row }
            .bind(to: viewModel.selectedIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        // refresh
        placeTableView.refreshControl = UIRefreshControl()

        placeTableView.refreshControl?.rx
            .controlEvent(.valueChanged)
            .map { _ in () }
            .bind(to: viewModel.reload)
            .disposed(by: bag)

        viewModel.activating
            .distinctUntilChanged()
            .map { !$0 }
            .filter { $0 == false }
            .emit(onNext: { [weak self] _ in
                self?.placeTableView.refreshControl?.endRefreshing()
            })
            .disposed(by: bag)

        viewModel.placeTableViewHidden
            .drive(placeTableView.rx.isHidden)
            .disposed(by: bag)

        viewModel.placeTableViewHidden
            .map { !$0 }
            .drive(emptyView.rx.isHidden)
            .disposed(by: bag)

        // more fetching

        placeTableView.rx.contentOffset
            .map { [unowned self] in placeTableView.isNearTheBottomEdge($0) }
            .distinctUntilChanged()
            .filter { $0 == true }
            .map { _ in () }
            .bind(to: viewModel.moreFetching)
            .disposed(by: bag)

        viewModel.placeListCellVMs
            .drive(placeTableView.rx.items) { tv, idx, vm in
                guard let cell = tv.dequeueReusableCell(withIdentifier: PlaceListCell.identyfier, for: IndexPath(row: idx, section: 0)) as? PlaceListCell else { return UITableViewCell() }
                cell.bind(vm)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushPlaceDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let placeDetailVC = PlaceDetailViewController()
                placeDetailVC.bind(viewModel)
                self.navigationController?.pushViewController(placeDetailVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.presentFilterVC
            .emit(onNext: { [weak self] filterVM in
                guard let self = self else { return }
                let filterVC = FilterViewController()
                filterVC.befViewModel = viewModel
                filterVC.bind(filterVM)

                // MDC 바텀 시트로 설정
                let bottomSheet: MDCBottomSheetController = .init(contentViewController: filterVC)
                bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                                          height: filterVC.viewHeight)
                self.present(bottomSheet, animated: true, completion: nil)
            })
            .disposed(by: bag)

        viewModel.presentSortVC
            .emit(onNext: { [weak self] sortVM in
                guard let self = self else { return }
                let sortVC = SortViewController()
                sortVC.befViewModel = viewModel
                sortVC.bind(sortVM)

                // MDC 바텀 시트로 설정
                let bottomSheet: MDCBottomSheetController = .init(contentViewController: sortVC)
                bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width,
                                                          height: sortVC.viewHeight)
                self.present(bottomSheet, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }

    private func layout() {
        [
            searchNavigationView,
            placeTableView,
            emptyView,
        ].forEach { view.addSubview($0) }

        searchNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(74.0)
        }

        placeTableView.snp.makeConstraints {
            $0.top.equalTo(searchNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        emptyView.snp.makeConstraints {
            $0.edges.equalTo(placeTableView)
        }
    }
}
