//
//  RoundLabelView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/01.
//

import UIKit
import RxSwift

class RoundLabelView: UIView {
    
    public lazy var label = UILabel().then {
        $0.textAlignment = .center
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height * 0.5
    }
    
    func bind(_ viewModel: RoundLabelViewModel) {
        viewModel.setContent
            .drive(label.rx.text)
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(13.0)
            $0.top.bottom.equalToSuperview().inset(5.0)
        }
    }
    
}
