//
//  PlaceDetailHeaderView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/08.
//

import RxSwift
import UIKit

class PlaceDetailHeaderView: UIView {
  

    public static let identyfier = "PlaceDetailHeaderView"
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

    func bind(_ viewModel: PlaceDetailHeaderViewModel) {
       
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        // MARK: make constraints

    }
}
