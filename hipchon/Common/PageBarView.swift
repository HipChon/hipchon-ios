//
//  PageBarView.swift
//  hipchon
//
//  Created by 김범수 on 2022/04/01.
//

import RxSwift
import UIKit

class PageBarView: UIView {

    private lazy var currentView = UIView().then {
        $0.backgroundColor = .black
        $0.layer.cornerRadius = 1.0
    }

    private let bag = DisposeBag()
    var viewModel: PageBarViewModel?

    override init(frame _: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 9.0
        
//        viewModel?.setBar
//            .drive(onNext: { ratio, count in
//                self.currentView.snp.remakeConstraints {
//                    $0.top.bottom.equalToSuperview()
//                    $0.width.equalTo((self.frame.width) / Double(count))
//                    $0.leading.equalToSuperview().inset((self.frame.width) * ratio)
//                }
//            })
//            .disposed(by: bag)
    }

    func bind(_ viewModel: PageBarViewModel) {
        self.viewModel = viewModel
    }

    private func attribute() {
        backgroundColor = .gray02
        layer.cornerRadius = 1.0
    }

    private func layout() {
        addSubview(currentView)

        currentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
