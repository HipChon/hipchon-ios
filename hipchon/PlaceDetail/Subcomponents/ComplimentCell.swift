//
//  ComplimentCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/09.
//

import UIKit
import RxSwift

class ComplimentCell: UITableViewCell {
    
    private lazy var insideView = UIView().then {
        $0.layer.cornerRadius = 5.0
        $0.layer.masksToBounds = true
    }
    
    private lazy var logoImageView = UIImageView().then { _ in
    }
    
    private lazy var complimentLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.textAlignment = .left
    }
    
    private lazy var countLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .semibold)
        $0.textAlignment = .right
    }
    
    public static let identyfier = "ComplimentCell"
    private let bag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: ComplimentCellViewModel) {
        viewModel.logoImage
            .drive(logoImageView.rx.image)
            .disposed(by: bag)
        
        viewModel.complimentContent
            .drive(complimentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.count
            .map { "+\($0)" }
            .drive(countLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.backgroundColor
            .drive(insideView.rx.backgroundColor)
            .disposed(by: bag)
    }
    
    private func attribute() {

    }
    
    private func layout() {
        addSubview(insideView)
        [
            logoImageView,
            complimentLabel,
            countLabel
        ].forEach {
            insideView.addSubview($0)
        }
        
        insideView.snp.makeConstraints {
            $0.leading.trailing.top.equalToSuperview()
            $0.height.equalTo(38.0)
        }
        
        logoImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(1.0)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28.0)
        }
        
        complimentLabel.snp.makeConstraints {
            $0.leading.equalTo(logoImageView.snp.trailing).offset(7.0)
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(countLabel.snp.leading).offset(7.0)
        }
        
        countLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(11.0)
            $0.centerY.equalToSuperview()
        }
    }
}
