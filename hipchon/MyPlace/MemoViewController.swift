//
//  MemoViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/17.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class MemoViewController: UIViewController {
    // MARK: Property
    
    private lazy var memoView = UIView().then {
        $0.backgroundColor = .secondary_yellow
        $0.layer.cornerRadius = 8.0
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_: MemoViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        // MARK: scene
    }

    func attribute() {
//        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        memoView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func layout() {
        [
            memoView
        ].forEach {
            view.addSubview($0)
        }
        
        memoView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40.0)
            $0.height.equalTo(207.0)
        }
    }
}
