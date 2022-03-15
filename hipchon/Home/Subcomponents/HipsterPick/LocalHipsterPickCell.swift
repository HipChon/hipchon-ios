//
//  LocalHipsterPickCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxSwift
import UIKit

class LocalHipsterPickCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var regionLabelView = RoundLabelView().then {
        $0.label.font = .AppleSDGothicNeo(size: 14.0, type: .medium)
        $0.label.textColor = .black
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .bold) // Todo Extra Bold
        $0.textColor = .white
        $0.textAlignment = .left
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 12.0, type: .medium)
        $0.textColor = .white
        $0.textAlignment = .left
    }

    public static let identyfier = "LocalHipsterPickCell"
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

    func bind(_ viewModel: LocalHipsterPickCellViewModel) {
        
        regionLabelView.bind(viewModel.regionLabelVM)
        
        // MARK: viewModel -> view
        
        viewModel.imageURL
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
        
        viewModel.title
            .drive(titleLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.subTitle
            .drive(subTitleLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        layer.masksToBounds = true
        layer.cornerRadius = 2.0
    }

    private func layout() {
        [
            imageView,
            regionLabelView,
            titleLabel,
            subTitleLabel
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        regionLabelView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(16.0)
        }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16.0)
            $0.bottom.equalTo(subTitleLabel.snp.top).offset(-8.0)
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalToSuperview().inset(16.0)
        }
    }
}
