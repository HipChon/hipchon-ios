//
//  PlaceListCell.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/02.
//

import RxSwift
import UIKit

class PlaceListCell: UITableViewCell {
    private lazy var placeImageCollectView = UICollectionView(frame: .zero,
                                                              collectionViewLayout: UICollectionViewLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = UIScreen.main.bounds.size.width - 20.0 * 2
        let cellHeight = width * ((255.0 + 16.0) / 351.0)
        let height = cellHeight - 89.0 - 16.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(ImageURLCell.self, forCellWithReuseIdentifier: ImageURLCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = true

        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = 5.0
        $0.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }

    private lazy var pageCountView = PageCountView().then { _ in
    }

    private lazy var placeInfoView = UIView().then {
        $0.backgroundColor = .white
    }

    private lazy var placeNameLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 18.0, type: .bold)
        $0.textAlignment = .left
    }

    private lazy var regionLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 13.0, type: .regular)
        $0.textColor = .typography_secondary
        $0.textAlignment = .left
    }

    private lazy var keywordView = KeywordView().then { _ in
    }

    private lazy var bookmarkButton = UIImageView().then {
        $0.image = UIImage(named: "bookmarkCount") ?? UIImage()
    }

    private lazy var bookmarkCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .gray04
    }

    private lazy var reviewCountImageView = UIImageView().then {
        $0.image = UIImage(named: "reviewCount") ?? UIImage()
    }

    private lazy var reviewCountLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .gray04
    }

    public static let identyfier = "PlaceListCell"
    private let bag = DisposeBag()
    var viewModel: PlaceListCellViewModel?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8.0, left: 20.0, bottom: 8.0, right: 20.0))
    }

    func bind(_ viewModel: PlaceListCellViewModel) {
        // MARK: subViewModels

        self.viewModel = viewModel
        placeImageCollectView.dataSource = nil
        placeImageCollectView.delegate = nil
        pageCountView.bind(viewModel.pageCountVM)

        viewModel.keywordVM
            .drive(onNext: { [weak self] viewModel in
                self?.keywordView.bind(viewModel)
            })
            .disposed(by: bag)

        // MARK: view -> viewModel

        placeImageCollectView.rx.contentOffset
            .compactMap { [unowned self] in Int(($0.x + self.contentView.frame.width / 2) / self.contentView.frame.width) }
            .distinctUntilChanged()
            .bind(to: viewModel.currentIdx)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.placeImageURLs
            .drive(placeImageCollectView.rx.items) { tv, row, data in
                guard let cell = tv.dequeueReusableCell(withReuseIdentifier: ImageURLCell.identyfier,
                                                        for: IndexPath(row: row, section: 0)) as? ImageURLCell else { return UICollectionViewCell() }
                let viewModel = ImageURLCellViewModel(data)
                cell.bind(viewModel)
                return cell
            }
            .disposed(by: bag)

        viewModel.name
            .drive(placeNameLabel.rx.text)
            .disposed(by: bag)

        viewModel.region
            .drive(regionLabel.rx.text)
            .disposed(by: bag)

        viewModel.bookmarkCount
            .map { "\($0)" }
            .drive(bookmarkCountLabel.rx.text)
            .disposed(by: bag)

        viewModel.reviewCount
            .map { "\($0)" }
            .drive(reviewCountLabel.rx.text)
            .disposed(by: bag)
    }

    private func attribute() {
        contentView.layer.cornerRadius = 5.0
        contentView.addShadow(offset: CGSize(width: 2.0, height: 2.0))
        contentView.backgroundColor = .white
        selectionStyle = .none
        layer.masksToBounds = true
    }

    private func layout() {
        // MARK: title

        let titleSpacingView = UIView()
        titleSpacingView.snp.makeConstraints {
            $0.width.equalTo(frame.width).priority(.low)
        }

        regionLabel.snp.makeConstraints {
            $0.width.equalTo(frame.width).priority(.high)
        }

        let titleStackView = UIStackView(arrangedSubviews: [placeNameLabel, regionLabel, titleSpacingView])
        titleStackView.axis = .horizontal
        titleStackView.alignment = .fill
        titleStackView.distribution = .fill
        titleStackView.spacing = 9.0

        // MARK: count

        [
            bookmarkButton,
            reviewCountImageView,
        ].forEach {
            $0.snp.makeConstraints {
                $0.width.height.equalTo(20.0)
            }
        }

        let countSpacingView = UIView()
        countSpacingView.snp.makeConstraints {
            $0.width.equalTo(frame.width).priority(.low)
        }

        let countStackView = UIStackView(arrangedSubviews: [reviewCountImageView, reviewCountLabel, bookmarkButton, bookmarkCountLabel])
        countStackView.axis = .horizontal
        countStackView.alignment = .center
        countStackView.distribution = .equalSpacing
        countStackView.spacing = 12.0

        [
            placeImageCollectView,
            pageCountView,
            placeInfoView,

        ].forEach { contentView.addSubview($0) }

        placeImageCollectView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            let width = UIScreen.main.bounds.size.width - 20.0 * 2
            let cellHeight = width * ((255.0 + 16.0) / 351.0)
            let height = cellHeight - 89.0 - 16.0
            $0.height.equalTo(height)
//            $0.bottom.equalTo(placeInfoView.snp.top)
        }

        pageCountView.snp.makeConstraints {
            $0.trailing.equalTo(placeImageCollectView).inset(16.0)
            $0.bottom.equalTo(placeImageCollectView).inset(16.0)
        }

        placeInfoView.snp.makeConstraints {
            $0.height.equalTo(89.0)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }

        [
            titleStackView,
            keywordView,
            countStackView,
        ].forEach {
            placeInfoView.addSubview($0)
        }

        titleStackView.snp.makeConstraints {
            $0.leading.top.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(21.0)
        }

        keywordView.snp.makeConstraints {
            $0.leading.equalTo(titleStackView)
            $0.top.equalTo(titleStackView.snp.bottom).offset(8.0)
            $0.height.equalTo(28.0)
        }

        countStackView.snp.makeConstraints {
            $0.centerY.equalTo(keywordView)
            $0.trailing.equalToSuperview().inset(16.0)
            $0.height.equalTo(20.0)
        }
    }
}

extension PlaceListCell: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity _: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
        let layout = placeImageCollectView.collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidthIncludingSpacing = layout.itemSize.width + layout.minimumLineSpacing

        // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
        // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludingSpacing
        var roundedIndex = round(index)

        // scrollView, targetContentOffset의 좌표 값으로 스크롤 방향을 알 수 있다.
        // index를 반올림하여 사용하면 item의 절반 사이즈만큼 스크롤을 해야 페이징이 된다.
        // 스크로로 방향을 체크하여 올림,내림을 사용하면 좀 더 자연스러운 페이징 효과를 낼 수 있다.
        if scrollView.contentOffset.x > targetContentOffset.pointee.x {
            roundedIndex = floor(index)
        } else {
            roundedIndex = ceil(index)
        } // 위 코드를 통해 페이징 될 좌표값을 targetContentOffset에 대입하면 된다.
        offset = CGPoint(x: roundedIndex * cellWidthIncludingSpacing, // - scrollView.contentInset.left,
                         y: -scrollView.contentInset.top)

        targetContentOffset.pointee = offset
    }
}
