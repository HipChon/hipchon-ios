//
//  PlaceListViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import UIKit

class PlaceListViewController: UIViewController {
    private lazy var placeList = UITableView().then {
        $0.backgroundColor = .white
        $0.register(PlaceListCell.self, forCellReuseIdentifier: PlaceListCell.identyfier)
        $0.rowHeight = view.frame.width * (300.0 / 350.0)
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
        viewModel.places
            .drive(placeList.rx.items) { tv, idx, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: PlaceListCell.identyfier, for: IndexPath(row: idx, section: 0)) as? PlaceListCell else { return UITableViewCell() }
                let placeListCellViewModel = PlaceListCellViewModel(data)
                cell.bind(placeListCellViewModel)

                return cell
            }
            .disposed(by: bag)
    }

    private func attribute() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .systemBackground

        navigationController?.navigationItem.title = "장소 검색"
        navigationController?.navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.backItem?.title = ""
    }

    private func layout() {
        [
            placeList,
        ].forEach { view.addSubview($0) }

        placeList.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16.0)
        }
    }
}
