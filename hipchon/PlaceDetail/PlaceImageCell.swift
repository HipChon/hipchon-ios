//
//  PlaceImageCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import Foundation
import UIKit
import RxSwift

class PlaceImageCell: UICollectionViewCell {
    
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    public static let identyfier = "PlaceImageCell"
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PlaceImageCellViewModel) {
        viewModel.url
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)
    }
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            imageView
        ].forEach { addSubview($0) }
        
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
