//
//  MyCommentCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/20.
//

import RxSwift
import RxCocoa

class MyCommentCell: UITableViewCell {
    
    private lazy var reviewImageView = UIImageView().then  { _ in
        
    }
    
    private lazy var contentLabel = UILabel().then {
        $0.font  = .AppleSDGothicNeo(size: 16.0, type: .regular)
        $0.textColor = .black
        $0.numberOfLines = 2
    }
    
    private lazy var dateLabel = UILabel().then {
        $0.font  = .AppleSDGothicNeo(size: 13.0, type: .regular)
        $0.textColor = .gray04
    }
    
    private lazy var borderView = UIView().then {
        $0.backgroundColor = .gray_border
    }
    
    
    public static let identyfier = "MyCommentCell"
    private let bag = DisposeBag()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MyCommentCellViewModel) {
        
        viewModel.imageURL
            .drive(reviewImageView.rx.setImageKF)
            .disposed(by: bag)
        
        viewModel.content
            .drive(contentLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.date
            .drive(dateLabel.rx.text)
            .disposed(by: bag)
    }
    
    private func attribute() {
        backgroundColor = .white
        selectionStyle = .none
    }
    
    private func layout() {
        [
            reviewImageView,
            contentLabel,
            dateLabel,
            borderView
        ].forEach {
            addSubview($0)
        }
        
        reviewImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.width.height.equalTo(80.0)
            $0.centerY.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(reviewImageView.snp.trailing).offset(16.0)
            $0.trailing.equalToSuperview().inset(20.0)
            $0.top.equalToSuperview().inset(30.0)
        }
        
        dateLabel.snp.makeConstraints {
            $0.leading.equalTo(contentLabel)
            $0.bottom.equalToSuperview().inset(18.0)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalToSuperview()
            $0.height.equalTo(1.0)
        }
    }
}
