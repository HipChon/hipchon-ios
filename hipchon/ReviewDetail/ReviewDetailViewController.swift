//
//  ReviewDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ReviewDetailViewController: UIViewController {
    // MARK: Property

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

    func bind(_ viewModel: ReviewDetailViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        // MARK: scene
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {}
}
