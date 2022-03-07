//
//  ReviewListView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import RxSwift
import UIKit

class ReviewListView: UIView {
    
    private lazy var reviewList = UITableView().then {
        $0.backgroundColor = .white
        $0.register(ReviewListCell.self, forCellReuseIdentifier: ReviewListCell.identyfier)
        $0.rowHeight = 440.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: ReviewListViewModel) {
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

    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        [
            reviewList
        ].forEach {
            addSubview($0)
        }
        
        reviewList.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    
    
}
