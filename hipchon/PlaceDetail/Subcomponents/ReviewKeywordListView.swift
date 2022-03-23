//
//  ReviewKeywordListView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import RxSwift
import UIKit

class ReviewKeywordListView: UIView {
    private lazy var reviewLabelImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewWhite") ?? UIImage()
    }

    private lazy var reviewLabel = UILabel().then {
        $0.text = "키워드 리뷰 top3"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }

    private lazy var firstKeywordView = KeywordDetailView().then { _ in
    }

    private lazy var secondKeywordView = KeywordDetailView().then { _ in
    }

    private lazy var thirdKeywordView = KeywordDetailView().then { _ in
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
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

    func bind(_ viewModel: ReviewKeywordListViewModel) {
        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.firstKeywordVM
            .drive(onNext: { [weak self] in
                self?.firstKeywordView.bind($0)
            })
            .disposed(by: bag)

        viewModel.secondKeywordVM
            .drive(onNext: { [weak self] in
                self?.secondKeywordView.bind($0)
            })
            .disposed(by: bag)

        viewModel.thirdKeywordVM
            .drive(onNext: { [weak self] in
                self?.thirdKeywordView.bind($0)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            reviewLabelImageView,
            reviewLabel,
            firstKeywordView,
            secondKeywordView,
            thirdKeywordView,
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

        firstKeywordView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(reviewLabel.snp.bottom).offset(23.0)
            $0.height.equalTo(40.0)
        }

        secondKeywordView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(firstKeywordView.snp.bottom).offset(8.0)
            $0.height.equalTo(40.0)
        }

        thirdKeywordView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(secondKeywordView.snp.bottom).offset(8.0)
            $0.height.equalTo(40.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
