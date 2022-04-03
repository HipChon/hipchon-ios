//
//  MyPlaceCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxSwift
import UIKit

class MyPlaceCell: UITableViewCell {
    private lazy var placeImageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }

    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 18.0, type: .bold)
    }

    private lazy var sectorLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray06
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray06
    }

    private lazy var bookmarkImageView = UIImageView().then {
        $0.image = UIImage(named: "bookmarkCount") ?? UIImage()
        $0.contentMode = .center
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var reviewImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewCount") ?? UIImage()
        $0.contentMode = .center
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .GmarketSans(size: 12.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var memoButton = UIButton().then {
        $0.layer.cornerRadius = 2.0
        $0.backgroundColor = .gray01
        $0.setTitle("메모", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.setTitleColor(.black.withAlphaComponent(0.6), for: .normal)
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 16.0)
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    public static let identyfier = "ReviewListCell"
    private let bag = DisposeBag()
    var viewModel: MyPlaceCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: MyPlaceCellViewModel) {
        self.viewModel = viewModel

        // MARK: view -> viewModel

        memoButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.memoButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.imageURL
            .drive(placeImageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.sector
            .drive(sectorLabel.rx.text)
            .disposed(by: bag)

        viewModel.address
            .drive(addressLabel.rx.text)
            .disposed(by: bag)

        viewModel.bookmarkCount
            .map { "\($0)" }
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewCount
            .map { "\($0)" }
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)

        viewModel.memoContent
            .drive(memoButton.rx.title())
            .disposed(by: bag)

        viewModel.memoColor
            .drive(memoButton.rx.backgroundColor)
            .disposed(by: bag)

        // MARK: scene

        viewModel.presentMemoVC
            .emit(onNext: { viewModel in
                guard let topVC = UIApplication.topViewController() else { return }
                let memoVC = MemoViewController()
                memoVC.bind(viewModel)

                memoVC.providesPresentationContextTransitionStyle = true
                memoVC.definesPresentationContext = true
                memoVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                memoVC.view.backgroundColor = UIColor(white: 0.4, alpha: 0.3)

                topVC.tabBarController?.present(memoVC, animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    private func attribute() {
        selectionStyle = .none
    }

    private func layout() {
        // MARK: count

        [
            placeImageView,
            placeNameLabel,
            sectorLabel,
            addressLabel,
            bookmarkImageView,
            bookmarkCountLabel,
            reviewImageView,
            reviewCountLabel,
            memoButton,
            boundaryView,
        ].forEach { contentView.addSubview($0) }

        placeImageView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(120.0)
        }

        placeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(22.0)
            $0.trailing.equalTo(placeImageView.snp.leading).offset(-16.0)
            $0.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(19.0)
        }

        sectorLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeNameLabel)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(20.0)
            $0.height.equalTo(17.0)
        }

        addressLabel.snp.makeConstraints {
            $0.leading.trailing.equalTo(placeNameLabel)
            $0.top.equalTo(sectorLabel.snp.bottom).offset(8)
            $0.height.equalTo(17.0)
        }

        bookmarkImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23.0)
            $0.top.equalTo(addressLabel.snp.bottom).offset(12.0)
            $0.width.height.equalTo(20.0)
        }

        bookmarkCountLabel.snp.makeConstraints {
            $0.leading.equalTo(bookmarkImageView.snp.trailing).offset(12.0)
            $0.centerY.equalTo(bookmarkImageView)
        }

        reviewImageView.snp.makeConstraints {
            $0.leading.equalTo(bookmarkCountLabel.snp.trailing).offset(12.0)
            $0.centerY.equalTo(bookmarkImageView)
            $0.width.height.equalTo(20.0)
        }

        reviewCountLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(12.0)
            $0.centerY.equalTo(bookmarkImageView)
        }

        memoButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(placeImageView.snp.bottom).offset(13.0)
            $0.height.equalTo(40.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
