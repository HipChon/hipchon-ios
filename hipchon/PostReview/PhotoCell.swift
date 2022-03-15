//
//  PhotoCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/13.
//

import RxSwift
import UIKit

class PhotoCell: UICollectionViewCell {
    private lazy var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
    }
    
    private lazy var cancleButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle"), for: .normal)
    }

    public static let identyfier = "PhotoCell"
    var bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        bag = DisposeBag()
    }

    func bind(_ viewModel: PhotoCellViewModel) {
        
        cancleButton.rx.tap
            .throttle(.seconds(2), scheduler: MainScheduler.instance)
            .bind(to: viewModel.cancleButtonTapped)
            .disposed(by: bag)
        
        viewModel.image
            .drive(imageView.rx.image)
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .white
    }

    private func layout() {
        [
            imageView,
            cancleButton
        ].forEach { addSubview($0) }

        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancleButton.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(14.0)
            $0.width.height.equalTo(13.0)
        }
    }
}
