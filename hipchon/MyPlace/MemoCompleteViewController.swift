//
//  MemoCompleteViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/30.
//

import RxSwift
import UIKit

class MemoCompleteViewController: UIViewController {
    private lazy var insideView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8.0
        $0.layer.masksToBounds = true
    }

    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "memo") ?? UIImage()
    }

    private lazy var label = UILabel().then {
        $0.text = "나만의 메모 작성 완료!"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
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
            imageView,
            label,
        ].forEach {
            insideView.addSubview($0)
        }

        imageView.snp.makeConstraints {
            $0.width.equalTo(156.0)
            $0.height.equalTo(192.0)
            $0.top.equalToSuperview().offset(38.0)
            $0.centerX.equalToSuperview()
        }

        label.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(41.0)
            $0.centerX.equalToSuperview()
        }
    }

    @objc func handleTap(sender _: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
}
