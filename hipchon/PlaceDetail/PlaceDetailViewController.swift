//
//  PlaceDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit
import RxDataSources

class PlaceDetailViewController: UIViewController {
    // MARK: Property

    private lazy var backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    }
    
    private lazy var entireCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {
        
        $0.delegate = nil
        $0.dataSource = nil
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 0.0
        let width = view.frame.width
        let height = 440.0
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
        layout.headerReferenceSize = CGSize(width: width, height: 1261.0) 
        $0.collectionViewLayout = layout
        
        $0.register(PlaceReviewCell.self, forCellWithReuseIdentifier: PlaceReviewCell.identyfier)
        $0.register(PlaceDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaceDetailHeaderView.identyfier)
        $0.showsVerticalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = false
    }

    typealias PlaceSectionModel = SectionModel<PlaceDetailHeaderViewModel, PlaceReviewCellViewModel>
    typealias PlaceDataSource = RxCollectionViewSectionedReloadDataSource<PlaceSectionModel>
    private var bag = DisposeBag()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        entireCollectionView.delegate = nil
        entireCollectionView.dataSource = nil
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: PlaceDetailViewModel) {

        entireCollectionView.delegate = nil
        entireCollectionView.dataSource = nil
        
        // MARK: view -> viewModel

        entireCollectionView.rx.modelSelected(ReviewModel.self)
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.selectedReview)
            .disposed(by: bag)

        // MARK: viewModel -> view
     
        let dataSource = RxCollectionViewSectionedReloadDataSource<PlaceSectionModel>(configureCell: { _, collectionView, indexPath, viewModel in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PlaceReviewCell.identyfier,
                                                                for: indexPath) as? PlaceReviewCell else { return UICollectionViewCell() }
            cell.bind(viewModel)
            return cell
        })
        
        dataSource.configureSupplementaryView = { ds, collectionView, kind, indexPath -> UICollectionReusableView in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                               withReuseIdentifier: PlaceDetailHeaderView.identyfier, for: indexPath) as? PlaceDetailHeaderView
            else {
                return UICollectionReusableView()
            }
            let viewModel = ds.sectionModels[indexPath.row].model
            header.bind(viewModel)
            return header
        }

        Driver.combineLatest(viewModel.placeDetailHeaderVM, viewModel.placeReviewListCellVMs)
            .do(onNext: { _ in
                self.entireCollectionView.delegate = nil
                self.entireCollectionView.delegate = nil
                self.bag = DisposeBag()
            })
            .map { [PlaceSectionModel(model: $0, items: $1)] }
            .drive(entireCollectionView.rx.items(dataSource: dataSource))
            .disposed(by: bag)


        // MARK: scene
        
        viewModel.openURL
            .emit(onNext: {
                UIApplication.shared.open($0, options: [:], completionHandler: nil)
            })
            .disposed(by: bag)
        
        viewModel.share
            .emit(onNext: { [weak self] in
                let activityVC = UIActivityViewController(activityItems: ["asd", "def"],
                                                          applicationActivities: nil)
                activityVC.popoverPresentationController?.sourceView = self?.view
                self?.present(activityVC, animated: true, completion: nil)
            })
            .disposed(by: bag)

//
//        backButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                self?.navigationController?.popViewController(animated: true)
//            })
//            .disposed(by: bag)
//
//        viewModel.pushReviewDetailVC
//            .emit(onNext: { [weak self] viewModel in
//                guard let self = self else { return }
//                let reviewDetailVC = ReviewDetailViewController()
//                reviewDetailVC.bind(viewModel)
//                self.navigationController?.pushViewController(reviewDetailVC, animated: true)
//            })
//            .disposed(by: bag)
        
        viewModel.pushPostReviewVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self else { return }
                let postReviewVC = PostReviewViewController()
                postReviewVC.bind(viewModel)
                self.navigationController?.pushViewController(postReviewVC, animated: true)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
    }

    func layout() {

        [
            entireCollectionView
        ].forEach {
            view.addSubview($0)
        }
        
        entireCollectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.bottom.equalToSuperview()
        }

    }
}

extension PlaceDetailViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        let width = view.frame.width
        let height = 440.0
        return CGSize(width: width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.frame.width
        let height = 1261.0
        return CGSize(width: width, height: height)
    }
}
