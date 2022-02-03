//
//  DefaultViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import Foundation

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class DefaultViewController: UIViewController {
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

    func bind(_: DefaultViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        // MARK: scene
    }

    func attribute() {}

    func layout() {}
}
