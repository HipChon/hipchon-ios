//
//  ProfileViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import Pageboy
import RxCocoa
import RxSwift
import SnapKit
import Tabman
import UIKit

class ProfileViewController: TabmanViewController {
    // MARK: Property

    private lazy var profileImageButton = UIButton().then {
        $0.setImage(UIImage(named: "default_profile"), for: .normal)
        $0.layer.masksToBounds = true
    }

    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 20.0, type: .bold)
        $0.text = "로그인이 필요합니다"
    }

    private lazy var settingButton = UIButton().then {
        $0.setImage(UIImage(named: "setting") ?? UIImage(), for: .normal)
    }

    private lazy var topBarPositionView = UIView().then { _ in
    }

    private lazy var borderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var topBar = TMBar.ButtonBar().then { bar in
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.buttons.customize { button in
            button.tintColor = .gray03
            button.selectedTintColor = .black
            button.selectedFont = .GmarketSans(size: 16.0, type: .medium)
        }
        // 인디케이터 조정
        bar.indicator.weight = .medium
        bar.indicator.tintColor = .black
        bar.indicator.overscrollBehavior = .compress
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 0
        bar.backgroundColor = .white

        bar.layout.transitionStyle = .progressive
    }

    let myReviewVM = HashtagReviewViewModel(.myReview)
    let likeReviewVM = HashtagReviewViewModel(.likeReview)
    let myCommentVM = MyCommentViewModel()

    private lazy var viewControllers: [UIViewController] = {
        let myReviewVC = HashtagReviewViewController()
        myReviewVC.bind(myReviewVM)
        let likeReviewVC = HashtagReviewViewController()
        likeReviewVC.bind(likeReviewVM)
        let myCommentVC = MyCommentViewController()
        myCommentVC.bind(myCommentVM)

        return [myReviewVC, likeReviewVC, myCommentVC]
    }()

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
        setTopBar()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
        profileImageButton.layer.cornerRadius = profileImageButton.frame.width / 2
    }

    func bind(_ viewModel: ProfileViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        settingButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.settingButtonTapped)
            .disposed(by: bag)

        profileImageButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.profileImageButtonTapped)
            .disposed(by: bag)

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        viewModel.profileImageURL
            .drive(profileImageButton.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(onNext: { [weak self] in
                self?.setNameLabel($0)
            })
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushSettingVC
            .emit(onNext: { [weak self] viewModel in
                let settingVC = SettingViewController()
                settingVC.bind(viewModel)
                self?.tabBarController?.navigationController?.pushViewController(settingVC, animated: true)
            })
            .disposed(by: bag)

        viewModel.pushEditProfileVC
            .emit(onNext: { [weak self] viewModel in
                let editProfileVC = EditProfileViewController()
                editProfileVC.bind(viewModel)
                self?.navigationController?.pushViewController(editProfileVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {
        [
            profileImageButton,
            nameLabel,
            settingButton,
            topBarPositionView,
            borderView,
        ].forEach { view.addSubview($0) }

        profileImageButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18.0)
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(view.frame.width * (79.0 / 390.0))
        }

        nameLabel.snp.makeConstraints {
            $0.centerY.equalTo(profileImageButton)
            $0.leading.equalTo(profileImageButton.snp.trailing).offset(16.0)
        }

        settingButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(18.0)
            $0.width.height.equalTo(28.0)
        }

        topBarPositionView.snp.makeConstraints {
            $0.top.equalTo(profileImageButton.snp.bottom).offset(21.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
        }

        borderView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(topBarPositionView)
            $0.height.equalTo(1.0)
        }
    }

    private func setTopBar() {
        dataSource = self
        addBar(topBar, dataSource: self, at: .custom(view: topBarPositionView, layout: nil))
    }

    private func setNameLabel(_ name: String?) {
        if name != nil {
            nameLabel.text = name!
            nameLabel.font = .AppleSDGothicNeo(size: 20.0, type: .bold)
            nameLabel.textColor = .black
            nameLabel.numberOfLines = 1
            profileImageButton.isEnabled = true
            settingButton.isHidden = false
        } else {
            nameLabel.text = """
            로그인이
            필요합니다
            """
            nameLabel.font = .AppleSDGothicNeo(size: 16.0, type: .semibold)
            nameLabel.textColor = .gray04
            nameLabel.numberOfLines = 2
            profileImageButton.isEnabled = false
            settingButton.isHidden = true
        }
    }
}

extension ProfileViewController: PageboyViewControllerDataSource, TMBarDataSource {
    func numberOfViewControllers(in _: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for _: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController?
    {
        return viewControllers[index]
    }

    func defaultPage(for _: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }

    func barItem(for _: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        switch index {
        case 0:
            title = "내가 심은 모"
        case 1:
            title = "좋아요 한 모"
        case 2:
            title = "내가 쓴 댓글"
        default:
            title = ""
        }
        return TMBarItem(title: title)
    }
}
