//
//  LocalHipsterPickView.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift
import Then
import UIKit
import CHIPageControl

class LocalHipsterPickView: UIView {
    private lazy var titleLabel = UILabel().then {
        $0.text = "로컬 힙스터 픽"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }

    private lazy var localHipsterPickCollectionView = UICollectionView(frame: .zero,
                                                                       collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing = 8.0
        let width = 230.0
        let height = 284.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 30.0, bottom: 0.0, right: 30.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(LocalHipsterPickCell.self, forCellWithReuseIdentifier: LocalHipsterPickCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = false
        $0.backgroundColor = .gray_background
    }

    private lazy var pageControl = CHIPageControlJaloro().then {
        $0.radius = 0
        $0.tintColor = .black
        $0.currentPageTintColor = .white
        $0.padding = 0
    }

    private let bag = DisposeBag()
    var viewModel: LocalHipsterPickViewModel?

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        localHipsterPickCollectionView.rx.contentOffset
            .compactMap { [unowned self] in Int(($0.x + self.localHipsterPickCollectionView.frame.width / 2) / 230.0) }
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: 0)
            .drive(onNext: { [weak self] in
                //set progress with animation
                self?.pageControl.set(progress: $0, animated: true)
            })
            .disposed(by: bag)
    }

    func bind(_ viewModel: LocalHipsterPickViewModel) {
        self.viewModel = viewModel

        // MARK: view -> viewModel

        localHipsterPickCollectionView.rx.modelSelected(LocalHipsterPickModel.self)
            .bind(to: viewModel.selectedLocalHipsterPick)
            .disposed(by: bag)


        // MARK: viewModel -> view

        viewModel.localHipsterPicks
            .drive(localHipsterPickCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: LocalHipsterPickCell.identyfier, for: IndexPath(row: idx, section: 0)) as? LocalHipsterPickCell else { return UICollectionViewCell() }
                let viewModel = LocalHipsterPickCellViewModel(data)
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)
        
        viewModel.localHipsterPicks
            .map { $0.count }
            .drive(onNext: { [weak self] in
                self?.pageControl.numberOfPages = $0
            })
            .disposed(by: bag)
    }

    private func attribute() {
        backgroundColor = .gray_background
    }

    private func layout() {
        [
            titleLabel,
            localHipsterPickCollectionView,
            pageControl,
        ].forEach { addSubview($0) }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.top.equalToSuperview().inset(20.0)
        }

        localHipsterPickCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(10.0)
            $0.height.equalTo(284.0)
        }

        pageControl.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30.0)
            $0.top.equalTo(localHipsterPickCollectionView.snp.bottom).offset(33.0)
            $0.height.equalTo(2.0)
        }
    }
}
