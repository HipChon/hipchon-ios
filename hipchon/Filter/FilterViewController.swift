//
//  FilterViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxSwift
import Then
import UIKit

class FilterViewController: UIViewController {
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "필터 및 정렬"
        $0.font = .systemFont(ofSize: 20.0, weight: .bold)
    }
    
    private lazy var cancleButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle"), for: .normal)
    }
    
    private let bag = DisposeBag()
    var viewHeight = 500.0

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewModel) {
        
    }
    
    func attribute() {
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        view.backgroundColor = .white
    }
    
    func layout() {
        [
            titleLabel,
            cancleButton
        ].forEach {
            view.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(41.0)
            $0.centerX.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(40.0)
            $0.height.width.equalTo(30.0)
        }
        
    }
}
