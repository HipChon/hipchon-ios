//
//  HipsterPickDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxSwift
import UIKit

class HipsterPickDetailViewController: UIViewController {
    private lazy var navigationView = NavigationView().then { _ in
    }

    private lazy var titleLabel = UILabel().then {
        $0.font = .GmarketSans(size: 22.0, type: .medium)
    }

    private lazy var hipsterPickDetailTableView = UITableView().then {
        $0.backgroundColor = .white
        $0.register(HipsterPickDetailCell.self, forCellReuseIdentifier: HipsterPickDetailCell.identyfier)
        $0.estimatedRowHeight = 600.0
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

    func bind(_ viewModel: HipsterPickDetailViewModel) {
        // MARK: subViewModels

        navigationView.bind(viewModel.navigationVM)

        // MARK: view -> viewModel

        rx.viewWillAppear
            .map { _ in () }
            .bind(to: viewModel.viewAppear)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)

        viewModel.hipsterPickDetailCellVMs
            .drive(hipsterPickDetailTableView.rx.items) { tv, idx, viewModel in
                guard let cell = tv.dequeueReusableCell(withIdentifier: HipsterPickDetailCell.identyfier,
                                                        for: IndexPath(row: idx, section: 0)) as? HipsterPickDetailCell else { return UITableViewCell() }
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pop
            .emit(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        view.backgroundColor = .white
    }

    private func layout() {
        [
            navigationView,
            titleLabel,
            hipsterPickDetailTableView,
        ].forEach {
            view.addSubview($0)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(68.0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationView.snp.bottom)
            $0.leading.trailing.equalToSuperview().inset(20.0)
        }

        hipsterPickDetailTableView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(22.0)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}
