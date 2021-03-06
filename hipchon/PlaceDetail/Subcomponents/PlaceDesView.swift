//
//  PlaceDesView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxSwift
import UIKit

class PlaceDesView: UIView {
    
    var viewModel: PlaceDesViewModel?
    
    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 24.0, type: .bold)
        $0.textColor = .black
    }

    private lazy var callButton = UIButton().then {
        $0.setImage(UIImage(named: "callWhite") ?? UIImage(), for: .normal)
    }

    private lazy var callLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.text = "전화"
        $0.textAlignment = .center
    }

    private lazy var shareButton = UIButton().then {
        $0.setImage(UIImage(named: "share") ?? UIImage(), for: .normal)
    }

    private lazy var shareLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.text = "공유"
        $0.textAlignment = .center
    }

    private lazy var reviewButton = UIButton().then {
        $0.setImage(UIImage(named: "reviewWhite") ?? UIImage(), for: .normal)
    }

    private lazy var reviewLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private lazy var bookmarkButton = UIButton().then {
        $0.setImage(UIImage(named: "bookmarkWhite") ?? UIImage(), for: .normal)
    }

    private lazy var bookmarkLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
    }

    private lazy var boundaryView = UIView().then {
        $0.backgroundColor = .gray02
    }

    private lazy var sectorImageView = UIImageView().then {
        $0.image = UIImage(named: "cupGray") ?? UIImage()
    }

    private lazy var sectorLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
        $0.textAlignment = .left
    }

    private lazy var businessHoursImageView = UIImageView().then {
        $0.image = UIImage(named: "clockGray") ?? UIImage()
    }

    private lazy var businessHoursLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
        $0.textAlignment = .left
    }

    private lazy var descriptionImageView = UIImageView().then {
        $0.image = UIImage(named: "houseGray") ?? UIImage()
    }

    private lazy var descriptionLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .gray05
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }

    private lazy var linkButton = UIButton().then {
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.setTitleColor(.primary_green, for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 22.0
        $0.layer.masksToBounds = true
        $0.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        $0.contentHorizontalAlignment = .left
        $0.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 16.0, bottom: 0.0, right: 60.0)
    }

    private lazy var reportButton = UIButton().then {
        $0.setImage(UIImage(named: "report"), for: .normal)
        $0.setTitle(" 신고하기", for: .normal)
        $0.setTitleColor(.gray04, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 12.0, type: .regular)
        
        var actions: [UIAction] = []
        let userReportAction = UIAction(title: "유저 신고 및 차단",
                                  image: nil) { [weak self] _ in
            self?.viewModel?.reportButtonTapped.accept(())
        }
        actions.append(userReportAction)

        let reviewReportAction = UIAction(title: "게시물 신고 및 차단",
                                    image: nil) { [weak self] _ in
            self?.viewModel?.reportButtonTapped.accept(())
        }
        actions.append(reviewReportAction)

        let menu = UIMenu(title: "", children: actions)
        $0.menu = menu
        $0.showsMenuAsPrimaryAction = true
    }

    private lazy var infoChangeButton = UIButton().then {
//        $0.setImage(UIImage(named: "arrowGray"), for: .normal)
        $0.setTitle("정보 수정 제안 >", for: .normal)
        $0.setTitleColor(.gray04, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
    }

    private lazy var arrowImageView = UIImageView().then {
        $0.image = UIImage(named: "arrowGray") ?? UIImage()
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

    func bind(_ viewModel: PlaceDesViewModel) {
        self.viewModel = viewModel
        
        // MARK: view -> viewModel

        callButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.callButtonTapped)
            .disposed(by: bag)

        shareButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.shareButtonTapped)
            .disposed(by: bag)

        reviewButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.reviewButtonTapped)
            .disposed(by: bag)

        bookmarkButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.bookmarkButtonTapped)
            .disposed(by: bag)

        linkButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.linkButtonTapped)
            .disposed(by: bag)
        
        infoChangeButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.infoChangeButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.setPlaceName
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.setReviewCount
            .map { "\($0)" }
            .drive(reviewLabel.rx.text)
            .disposed(by: bag)

        viewModel.setBookmarkCount
            .map { "\($0)" }
            .drive(bookmarkLabel.rx.text)
            .disposed(by: bag)

        viewModel.setBookmarkYn
            .compactMap { $0 == true ? UIImage(named: "bookmarkY") ?? UIImage() : UIImage(named: "bookmarkN") ?? UIImage() }
            .drive(bookmarkButton.rx.image)
            .disposed(by: bag)

        viewModel.setSector
            .drive(sectorLabel.rx.text)
            .disposed(by: bag)

        viewModel.setBusinessHours
            .drive(businessHoursLabel.rx.text)
            .disposed(by: bag)

        viewModel.setDescription
            .drive(descriptionLabel.rx.text)
            .disposed(by: bag)

        viewModel.setLink
            .drive(linkButton.rx.title())
            .disposed(by: bag)

        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:])
            })
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 15.0
        layer.maskedCorners = CACornerMask(arrayLiteral: .layerMinXMinYCorner, .layerMaxXMinYCorner)
    }

    private func layout() {
        let callStackView = UIStackView(arrangedSubviews: [callButton, callLabel])
        let shareStackView = UIStackView(arrangedSubviews: [shareButton, shareLabel])
        let reviewStackView = UIStackView(arrangedSubviews: [reviewButton, reviewLabel])
        let bookmarkStackView = UIStackView(arrangedSubviews: [bookmarkButton, bookmarkLabel])

        [
            callStackView,
            shareStackView,
            reviewStackView,
            bookmarkStackView,
        ].forEach {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .equalCentering
            $0.spacing = 10.0
        }

        let firstButtonBoundaryView = UIView()
        let secondButtonBoundaryView = UIView()
        let thirdButtonBoundaryView = UIView()
        [
            firstButtonBoundaryView,
            secondButtonBoundaryView,
            thirdButtonBoundaryView,
        ].forEach {
            $0.backgroundColor = .black
            $0.snp.makeConstraints {
                $0.width.equalTo(2.0)
                $0.height.equalTo(27.5)
            }
        }

        [
            callButton,
            shareButton,
            reviewButton,
            bookmarkButton,
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(30.0)
            }
        }

        let buttonStackView = UIStackView(arrangedSubviews: [callStackView,
                                                             firstButtonBoundaryView,
                                                             shareStackView,
                                                             secondButtonBoundaryView,
                                                             reviewStackView,
                                                             thirdButtonBoundaryView,
                                                             bookmarkStackView])
        buttonStackView.axis = .horizontal
        buttonStackView.alignment = .center
        buttonStackView.distribution = .equalSpacing
        buttonStackView.spacing = 0.0

        [
            placeNameLabel,
            buttonStackView,
            boundaryView,
            sectorImageView,
            sectorLabel,
            businessHoursImageView,
            businessHoursLabel,
            descriptionImageView,
            descriptionLabel,
            linkButton,
            reportButton,
            infoChangeButton,
            arrowImageView,
        ].forEach {
            addSubview($0)
        }

        placeNameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.top.equalToSuperview().inset(48.0)
        }

        buttonStackView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(40.0)
            $0.top.equalTo(placeNameLabel.snp.bottom).offset(24.0)
            $0.height.equalTo(60.0)
        }

        boundaryView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(buttonStackView.snp.bottom).offset(20.0)
            $0.height.equalTo(1.0)
        }

        sectorImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(boundaryView.snp.bottom).offset(20.0)
            $0.height.width.equalTo(25.0)
        }

        sectorLabel.snp.makeConstraints {
            $0.leading.equalTo(sectorImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(sectorImageView)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        businessHoursImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(sectorImageView.snp.bottom).offset(20.0)
            $0.height.width.equalTo(25.0)
        }

        businessHoursLabel.snp.makeConstraints {
            $0.leading.equalTo(businessHoursImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(businessHoursImageView)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        descriptionImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(businessHoursImageView.snp.bottom).offset(20.0)
            $0.height.width.equalTo(25.0)
        }

        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(descriptionImageView.snp.trailing).offset(8.0)
            $0.top.equalTo(descriptionImageView)
            $0.trailing.equalToSuperview().inset(20.0)
        }

        linkButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(16.0)
            $0.height.equalTo(44.0)
        }

        reportButton.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.centerY.equalTo(infoChangeButton)
        }

        infoChangeButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(linkButton.snp.bottom).offset(16.0)
        }

        arrowImageView.snp.makeConstraints {
            $0.trailing.equalTo(linkButton.snp.trailing).inset(16.0)
            $0.centerY.equalTo(linkButton)
            $0.width.equalTo(6.0)
            $0.height.equalTo(12.0)
        }
    }
}
