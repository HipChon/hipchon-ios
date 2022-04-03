//
//  ErrorAlertViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/29.
//

import RxSwift
import UIKit

class ErrorAlertViewController: UIViewController {
    private lazy var insideView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
    }

    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "error") ?? UIImage()
    }

    private lazy var label = UILabel().then {
        $0.text = """
        앗! 오류입니다
        다시 한번 시도해볼까요?
        """
        $0.font = .GmarketSans(size: 16.0, type: .medium)
        $0.textColor = .gray04
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }

    private lazy var completeButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.setBackgroundColor(.primary_green, for: .normal)
    }

    private lazy var cancleButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle"), for: .normal)
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
        attribute()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind() {
        Observable.merge(
            completeButton.rx.tap.map { _ in () },
            cancleButton.rx.tap.map { _ in () }
        )
        .throttle(.seconds(2), scheduler: MainScheduler.instance)
        .asSignal(onErrorJustReturn: ())
        .emit(onNext: {
            guard let alertVC = UIApplication.topViewController() else { return }
            alertVC.dismiss(animated: true, completion: nil)
        })
        .disposed(by: bag)
    }

    private func attribute() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        insideView.removeGestureRecognizer(tapGesture)
    }

    private func layout() {
        view.addSubview(insideView)

        insideView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.95)
            $0.width.equalTo(290.0)
            $0.height.equalTo(323.0)
        }

        [
            cancleButton,
            imageView,
            label,
            completeButton,
        ].forEach {
            insideView.addSubview($0)
        }

        cancleButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(20.0)
            $0.trailing.equalToSuperview().inset(25.0)
            $0.width.height.equalTo(28.0)
        }

        imageView.snp.makeConstraints {
            $0.width.equalTo(142.0)
            $0.height.equalTo(164.0)
            $0.top.equalToSuperview().offset(28.0)
            $0.centerX.equalToSuperview().offset(-10.0)
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(13.0)
            $0.centerX.equalToSuperview()
        }

        completeButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48.0)
        }
    }

    @objc func handleTap(sender _: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}
