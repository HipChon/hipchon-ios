//
//  HashtagReivewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import UIKit
import RxSwift

class HashtagReviewCell: UICollectionViewCell {

    private lazy var insideView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.masksToBounds = false
        $0.layer.cornerRadius = 8.0
        $0.addShadow(offset: CGSize(width: 2.0, height: 2.0))
    }
    
    private lazy var imageView = UIImageView().then { _ in
    }
    
    private lazy var nameView = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var nameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .semibold)
        $0.textColor = .black
    }
    
    public static let identyfier = "HashtagReviewCell"
    private var bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }
    
    func bind(_ viewModel: HashtagReviewCellViewModel) {
        viewModel.imageURL
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
        
        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
    }
    
    private func layout() {
        
        contentView.addSubview(insideView)
        
        insideView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(4.0)
        }
        
        [
            imageView,
            nameView
        ].forEach {
            insideView.addSubview($0)
        }
        
        imageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(nameView.snp.top)
        }
        
        nameView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(48.0)
        }
        
        nameView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(13.0)
            $0.centerY.equalToSuperview()
        }
    }
    
}
