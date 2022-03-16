//
//  PlaceDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then
import UIKit

class PlaceDetailViewController: UIViewController {
    // MARK: Property

    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(named: "back"), for: .normal)
    }

    private lazy var entireTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.backgroundColor = .white
        $0.register(PlaceDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: PlaceDetailHeaderView.identyfier)
        $0.register(ReviewCell.self, forCellReuseIdentifier: ReviewCell.identyfier)
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private var bag = DisposeBag()
    var viewModel: PlaceDetailViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: PlaceDetailViewModel) {
        self.viewModel = viewModel
        entireTableView.rx.setDelegate(self).disposed(by: bag)

        // MARK: view -> viewModel

        entireTableView.rx.itemSelected
            .map { $0.row }
            .bind(to: viewModel.selectedReviewIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.reviewCellVms
            .drive(entireTableView.rx.items) { tv, _, viewModel in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ReviewCell.identyfier) as? ReviewCell else { return UITableViewCell() }
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:], completionHandler: nil)
            })
            .disposed(by: bag)

        viewModel.share
            .emit(onNext: { [weak self] in
                let activityVC = UIActivityViewController(activityItems: ["asd", "def"],
                                                          applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: bag)

        viewModel.pushReviewDetailVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let reviewDetailVC = ReviewDetailViewController()
                reviewDetailVC.bind(viewModel)
                self.navigationController?.pushViewController(reviewDetailVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.pushPostReviewVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let postReviewVC = PostReviewViewController()
                postReviewVC.bind(viewModel)
                self.navigationController?.pushViewController(postReviewVC, animated: true)
            })
            .disposed(by: bag)

        backButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            entireTableView,
            backButton,
        ].forEach {
            view.addSubview($0)
        }

        backButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(26.0)
            $0.top.equalToSuperview().inset(26.0)
            $0.width.height.equalTo(28.0)
        }

        entireTableView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

extension PlaceDetailViewController: UITableViewDelegate {
    func tableView(_: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        // TODO: reuse
        guard let viewModel = viewModel,
              let headerVM = viewModel.headerVM else { return UIView() }
        let header = PlaceDetailHeaderView()
        header.bind(headerVM)
        return header
    }

    func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
        return 1650.0
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 393.0
    }
}
