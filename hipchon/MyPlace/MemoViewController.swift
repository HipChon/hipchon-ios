//
//  MemoViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/17.
//

import RxCocoa
import RxSwift
import SnapKit
import UIKit

class MemoViewController: UIViewController {
    // MARK: Property
    
    private lazy var memoView = UIView().then {
        $0.backgroundColor = .gray01
        $0.layer.cornerRadius = 8.0
    }
    
    private lazy var contentTextView = UITextView().then {
        $0.backgroundColor = .gray01
        $0.isEditable = true
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .gray05
        $0.text = "나만의 메모를 남겨볼까요"
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var countLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.text = "0 / 30"
        $0.textColor = .gray05
    }
    
    private lazy var greenButton = UIButton().then {
        $0.backgroundColor = .primary_green
        $0.layer.borderColor = UIColor(hexString: "#08BB22")!.cgColor
        $0.layer.borderWidth = 2.0
    }

    private lazy var yelloButton = UIButton().then {
        $0.backgroundColor = .secondary_yellow
        $0.layer.borderColor = UIColor(hexString: "#FFC700")!.cgColor
        $0.layer.borderWidth = 2.0
    }

    private lazy var purpleButton = UIButton().then {
        $0.backgroundColor = .secondary_purple
        $0.layer.borderColor = UIColor(hexString: "#8C7BFF")!.cgColor
        $0.layer.borderWidth = 2.0
    }
    
    private lazy var blueButton = UIButton().then {
        $0.backgroundColor = .secondary_blue
        $0.layer.borderColor = UIColor(hexString: "#00B0FC")!.cgColor
        $0.layer.borderWidth = 2.0
    }

    private let bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        [
            greenButton,
            yelloButton,
            purpleButton,
            blueButton
        ].forEach {
            $0.clipsToBounds = true
            $0.layer.cornerRadius = $0.frame.width / 2
        }
    }

    func bind(_ viewModel: MemoViewModel) {
        // MARK: subViews Binding

        // MARK: view -> viewModel
        
        contentTextView.rx.text.orEmpty
            .bind(to: viewModel.inputContent)
            .disposed(by: bag)
        
        Observable.merge(
            greenButton.rx.tap.map { UIColor.primary_green },
            yelloButton.rx.tap.map { UIColor.secondary_yellow },
            purpleButton.rx.tap.map { UIColor.secondary_purple },
            blueButton.rx.tap.map { UIColor.secondary_blue }
        )
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.changedColor)
            .disposed(by: bag)
        
        
        // MARK: viewModel -> view
        
        viewModel.content
            .drive(contentTextView.rx.text)
            .disposed(by: bag)
        
        viewModel.color
            .drive(memoView.rx.backgroundColor)
            .disposed(by: bag)
        
        viewModel.color
            .drive(contentTextView.rx.backgroundColor)
            .disposed(by: bag)
        
        viewModel.contentCount
            .map { "\($0) / 30"}
            .drive(countLabel.rx.text)
            .disposed(by: bag)

        // MARK: scene
    }

    func attribute() {
//        view.alpha = 0
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        memoView.addGestureRecognizer(tapGesture)
        view.addGestureRecognizer(tapGesture)
    }

    @objc func handleTap(sender: UITapGestureRecognizer) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func layout() {
        [
            memoView
        ].forEach {
            view.addSubview($0)
        }
        
        memoView.snp.makeConstraints {
            $0.centerX.centerY.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(40.0)
            $0.height.equalTo(243.0)
        }
        
        [greenButton,
         yelloButton,
         purpleButton,
         blueButton
        ].forEach { button in
            button.snp.makeConstraints {
                $0.width.height.equalTo(21.0)
            }
        }
        
        let colorStackView = UIStackView(arrangedSubviews: [greenButton,
                                                            yelloButton,
                                                            purpleButton,
                                                            blueButton
                                                           ])
        colorStackView.axis = .horizontal
        colorStackView.distribution = .fill
        colorStackView.alignment = .fill
        colorStackView.spacing = 8.0
        
        [
            contentTextView,
            countLabel,
            colorStackView
        ].forEach {
            memoView.addSubview($0)
        }
        
        contentTextView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(32.0)
            $0.leading.trailing.equalToSuperview().inset(24.0)
            $0.height.equalTo(150.0)
        }
        
        countLabel.snp.makeConstraints {
            $0.bottom.equalTo(colorStackView.snp.top).offset(21.0)
            $0.trailing.equalToSuperview().inset(24.0)
        }
        
        colorStackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview().inset(21.0)
        }
        
    }
}
