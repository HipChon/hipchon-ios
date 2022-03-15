//
//  ReviewComplimentListView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import RxSwift
import UIKit

class ReviewComplimentListView: UIView {
    private lazy var reviewLabelImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewWhite") ?? UIImage()
    }

    private lazy var reviewLabel = UILabel().then {
        $0.text = "리뷰"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    private lazy var complimentsList = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ComplimentCell.self, forCellReuseIdentifier: ComplimentCell.identyfier)
        $0.rowHeight = 46.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: ReviewComplimentListViewModel) {
        // MARK: view -> viewModel

//        reviewList.rx.modelSelected(ReviewModel.self)
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .bind(to: viewModel.selectedReview)
//            .disposed(by: bag)
//
//        // MARK: viewModel -> view
//
        viewModel.complimentCellVMs
            .drive(complimentsList.rx.items) { tv, idx, vm in
                guard let cell = tv.dequeueReusableCell(withIdentifier: ComplimentCell.identyfier, for: IndexPath(row: idx, section: 0)) as? ComplimentCell else { return UITableViewCell() }
                cell.bind(vm)
                return cell
            }
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            reviewLabelImageView,
            reviewLabel,
            complimentsList,
            boundaryView,
        ].forEach {
            addSubview($0)
        }

        reviewLabelImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(25.0)
        }

        reviewLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewLabelImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(reviewLabelImageView)
        }

        complimentsList.snp.makeConstraints {
            $0.top.equalTo(reviewLabelImageView.snp.bottom).offset(14.0)
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.height.equalTo(130.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
