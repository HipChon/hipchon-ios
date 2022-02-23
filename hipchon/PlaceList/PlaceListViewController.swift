//
//  PlaceListViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import UIKit

class PlaceListViewController: UIViewController {
    private lazy var searchNavigationView = SearchNavigationView().then { _ in
    }

    private lazy var placeList = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identyfier)
        $0.rowHeight = view.frame.width * ((262.0 + 15.0) / (350.0 + 20.0 * 2))
        $0.separatorInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
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
        // MARK: view -> viewModel

        placeList.rx.modelSelected(PlaceModel.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedPlace)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.places
            .drive(placeList.rx.items) { tv, idx, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: PlaceListCell.identyfier, for: IndexPath(row: idx, section: 0)) as? PlaceListCell else { return UITableViewCell() }
                let placeListCellViewModel = PlaceListCellViewModel(data)
                cell.bind(placeListCellViewModel)

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
    }

    private func attribute() {
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemBackground
    }

    private func layout() {
        [
            searchNavigationView,
            placeList,
        ].forEach { view.addSubview($0) }

        searchNavigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }

        placeList.snp.makeConstraints {
            $0.top.equalTo(searchNavigationView.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
