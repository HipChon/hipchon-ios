//
//  SortViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/27.
//

import RxSwift
import RxViewController
import UIKit

class SortViewController: UIViewController {
    private lazy var reviewOrderButton = UIButton().then {
        $0.setTitle("후기순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var reviewCheckImageView = UIImageView().then {
        $0.image = UIImage(named: "checkBlack") ?? UIImage()
    }

    private lazy var bookmarkOrderButton = UIButton().then {
        $0.setTitle("저장순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var bookmarkCheckImageView = UIImageView().then {
        $0.image = UIImage(named: "checkBlack") ?? UIImage()
    }

    private lazy var distanceOrderButton = UIButton().then {
        $0.setTitle("거리순", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.black, for: .normal)
        $0.backgroundColor = .white
    }

    private lazy var distanceCheckImageView = UIImageView().then {
        $0.image = UIImage(named: "checkBlack") ?? UIImage()
    }

    private lazy var searchButton = UIButton().then {
        $0.setTitle("적용", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16.0, weight: .bold)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .black
    }
    
    private lazy var marginSearchButton = UIButton().then {
        $0.backgroundColor = .black
    }

    private let bag = DisposeBag()
    var befViewModel: PlaceListViewModel?
    var viewHeight = 240.0

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: SortViewModel) {
        viewModel.curSortType
            .drive(onNext: { [weak self] sort in
                self?.reviewCheckImageView.isHidden = sort != .review
                self?.bookmarkCheckImageView.isHidden = sort != .bookmark
                self?.distanceCheckImageView.isHidden = sort != .distance
            })
            .disposed(by: bag)

        Observable.merge(reviewOrderButton.rx.tap.map { _ in SortType.review },
                         bookmarkOrderButton.rx.tap.map { _ in SortType.bookmark },
                         distanceOrderButton.rx.tap.map { _ in SortType.distance })
            .bind(to: viewModel.sortType)
            .disposed(by: bag)

 
        Observable.merge(
            searchButton.rx.tap.map { _ in () },
            marginSearchButton.rx.tap.map { _ in () }
        )
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(viewModel.sortType)
            .subscribe(onNext: { [weak self] in
                guard let self = self,
                      let befViewModel = self.befViewModel else { return }
                befViewModel.sortType.onNext($0)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        view.backgroundColor = .white
    }

    private func layout() {
        let buttonStackView = UIStackView(arrangedSubviews: [reviewOrderButton,
                                                             bookmarkOrderButton,
                                                             distanceOrderButton,
                                                             searchButton])
        buttonStackView.axis = .vertical
        buttonStackView.alignment = .fill
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 0.0

        [
            reviewOrderButton,
            bookmarkOrderButton,
            distanceOrderButton,
        ].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(48.0)
            }
        }
        searchButton.snp.makeConstraints {
            $0.height.equalTo(65.0)
        }

        [
            buttonStackView,
            marginSearchButton,
            reviewCheckImageView,
            bookmarkCheckImageView,
            distanceCheckImageView,
        ].forEach {
            view.addSubview($0)
        }

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalToSuperview().inset(24.0)
        }
        
        marginSearchButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(buttonStackView.snp.bottom)
            $0.bottom.equalToSuperview()
        }

        reviewCheckImageView.snp.makeConstraints {
            $0.height.width.equalTo(17.0)
            $0.centerY.equalTo(reviewOrderButton)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        bookmarkCheckImageView.snp.makeConstraints {
            $0.height.width.equalTo(reviewCheckImageView)
            $0.centerY.equalTo(bookmarkOrderButton)
            $0.trailing.equalTo(reviewCheckImageView)
        }

        distanceCheckImageView.snp.makeConstraints {
            $0.height.width.equalTo(reviewCheckImageView)
            $0.centerY.equalTo(distanceOrderButton)
            $0.trailing.equalTo(reviewCheckImageView)
        }
    }
}
