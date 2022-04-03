//
//  HashtagReivewCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxSwift
import UIKit

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

    private lazy var hashtagImageView = UIImageView().then { _ in
    }

    public static let identyfier = "HashtagReviewCell"
    var bag = DisposeBag()
    var viewModel: HashtagReviewCellViewModel?
    
    private lazy var dotButton = UIButton().then {
        $0.setImage(UIImage(named: "dots"), for: .normal)
        
        
        var actions: [UIAction] = []
        let showAction = UIAction(title: "조회",
                                     image: nil) { [weak self] _ in
            self?.viewModel?.showTapped.onNext(())
        }
        actions.append(showAction)
        
        viewModel?.deleteEnable
            .filter { $0 == true }
            .drive(onNext: { _ in
                let deleteAction = UIAction(title: "삭제",
                                             image: nil) { [weak self] _ in
                    self?.viewModel?.deleteTapped.onNext(())
                }
                actions.append(deleteAction)
            })
            .disposed(by: bag)
        
        
        let menu = UIMenu(title: "", children: actions)
        $0.menu = menu
        $0.showsMenuAsPrimaryAction = true
    }

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

    func bind(_ viewModel: HashtagReviewCellViewModel) {
        self.viewModel = viewModel
        
        viewModel.imageURL
            .drive(imageView.rx.setImageKF)
            .disposed(by: bag)

        viewModel.name
            .drive(nameLabel.rx.text)
            .disposed(by: bag)

        viewModel.hashtagImageURL
            .drive(hashtagImageView.rx.setImageKF)
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
            nameView,
            hashtagImageView,
            dotButton,
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

        hashtagImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(11.0)
            $0.bottom.equalTo(nameView.snp.top).inset(10.0)
            $0.height.equalToSuperview().multipliedBy(0.4)
            $0.width.equalTo(hashtagImageView.snp.height).multipliedBy(58.0 / 77.0)
        }

        dotButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(13.0)
            $0.centerY.equalTo(nameLabel)
            $0.width.height.equalTo(17.0)
        }
    }
}
