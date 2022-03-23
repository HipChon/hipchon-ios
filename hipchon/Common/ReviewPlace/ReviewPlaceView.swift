//
//  ReviewPlaceButton.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/10.
//

import RxCocoa
import RxSwift
import UIKit

class ReviewPlaceView: UIView {
    private lazy var insideButton = UIButton().then { _ in
    }

    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .semibold)
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
        $0.textColor = .gray04
    }

    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmarkN") ?? UIImage(), for: .normal)
    }

    private lazy var bookmarkLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .light)
        $0.textColor = .gray04
        $0.text = "저장"
    }

    private lazy var shareButton = UIButton().then {
        $0.setImage(UIImage(named: "share") ?? UIImage(), for: .normal)
    }

    private lazy var shareLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .light)
        $0.textColor = .gray04
        $0.text = "공유"
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

    func bind(_ viewModel: ReviewPlaceViewModel) {
        // MARK: view -> viewModel

        insideButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.insideButtonTapped)
            .disposed(by: bag)

        bookmarkButton.rx.tap
            .bind(to: viewModel.bookmarkButtonTapped)
            .disposed(by: bag)

        shareButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.shareButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.placeName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        Driver.combineLatest(viewModel.sector, viewModel.address)
            .map { "\($0) • \($1)" }
            .drive(addressLabel.rx.text)
            .disposed(by: bag)

        viewModel.bookmarkYn
            .compactMap { $0 ? UIImage(named: "bookmarkY") : UIImage(named: "bookmarkN") }
            .drive(bookmarkButton.rx.image)
            .disposed(by: bag)
    }

    private func attribute() {
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        layer.cornerRadius = 22.0
        layer.masksToBounds = true
        backgroundColor = .gray_inside
        layer.borderColor = UIColor.gray02.cgColor
        layer.borderWidth = 1.0
    }

    private func layout() {
        let labelStackView = UIStackView(arrangedSubviews: [placeNameLabel, addressLabel])
        let bookmarkStackView = UIStackView(arrangedSubviews: [bookmarkButton, bookmarkLabel])
        let shareStackView = UIStackView(arrangedSubviews: [shareButton, shareLabel])

        [
            bookmarkButton,
            shareButton,
        ].forEach {
            $0.snp.makeConstraints {
                $0.height.width.equalTo(22.0)
            }
        }

        [
            labelStackView,
            bookmarkStackView,
            shareStackView,
        ].forEach {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 3.0
        }

        [
            labelStackView,
            insideButton,
            bookmarkStackView,
            shareStackView,
        ].forEach {
            addSubview($0)
        }

        labelStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(17.0)
            $0.trailing.equalTo(bookmarkStackView.snp.leading).offset(5.0)
            $0.top.equalToSuperview().inset(12.0)
            $0.bottom.equalToSuperview().inset(10.0)
        }

        insideButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        bookmarkStackView.snp.makeConstraints {
//            $0.trailing.equalTo(shareStackView.snp.leading).offset(18.0)
            $0.trailing.equalToSuperview().inset(62.0)
            $0.top.equalToSuperview().inset(11.0)
            $0.bottom.equalToSuperview().inset(9.0)
        }

        shareStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(17.0)
            $0.top.equalToSuperview().inset(11.0)
            $0.bottom.equalToSuperview().inset(9.0)
        }
    }
}
