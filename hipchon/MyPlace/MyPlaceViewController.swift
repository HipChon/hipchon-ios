//
//  MyPlaceViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class MyPlaceViewController: UIViewController {
    // MARK: Property

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        attribute()
    }

    func bind(_: MyPlaceViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel

        // MARK: viewModel -> view

        // MARK: scene
    }

    func attribute() {
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
    }

    func layout() {}
}
