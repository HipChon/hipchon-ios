//
//  SectorPlaceViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SectorPlaceViewController: UIViewController {
    // MARK: Property

    private lazy var placeTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(MyPlaceCell.self, forCellReuseIdentifier: MyPlaceCell.identyfier)
        $0.rowHeight = 211.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
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

    func bind(_ viewModel: SectorPlaceViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        placeTableView.rx.modelSelected(PlaceModel.self)
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedPlace)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.places
            .drive(placeTableView.rx.items) { tv, idx, data in
                guard let cell = tv.dequeueReusableCell(withIdentifier: MyPlaceCell.identyfier, for: IndexPath(row: idx, section: 0)) as? MyPlaceCell else { return UITableViewCell() }
                let myPlaceCellViewModel = MyPlaceCellViewModel(data)
                cell.bind(myPlaceCellViewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushPlaceDetailVC
            .emit(onNext: { [weak self] viewModel in
                let placeDetailVC = PlaceDetailViewController()
                placeDetailVC.bind(viewModel)
                self?.tabBarController?.navigationController?.pushViewController(placeDetailVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    func layout() {
        [
            placeTableView,
        ].forEach { view.addSubview($0) }

        placeTableView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(121.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}