//
//  FilterViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxSwift
import Then
import UIKit

class FilterViewController: UIViewController {
    private lazy var titleLabel = UILabel().then {
        $0.text = "빠른 검색"
        $0.font = .GmarketSans(size: 20.0, type: .medium)
    }

    private lazy var cancleButton = UIButton().then {
        $0.setImage(UIImage(named: "cancle"), for: .normal)
    }

    private lazy var personnelLabel = UILabel().then {
        $0.text = "인원"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
    }

    private lazy var personnelNumberView = UIView().then {
        $0.layer.cornerRadius = 16.5
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private lazy var personnelNumberLabel = UILabel().then {
        $0.text = "나만의"
        $0.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.textAlignment = .center
    }

    private lazy var plusButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .regular)
        $0.layer.cornerRadius = 11.5
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private lazy var minusButton = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .regular)
        $0.layer.cornerRadius = 11.5
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private lazy var petButton = UIButton().then {
        $0.setTitle("반려동물", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 14.0, type: .regular)
        $0.layer.cornerRadius = 16.5
        $0.layer.masksToBounds = true
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.lightGray.cgColor
    }

    private lazy var regionLabel = UILabel().then {
        $0.text = "지역"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
    }

    private lazy var regionCollectionView = UICollectionView(frame: .zero,
                                                             collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 20.0
        let width = 111.0
        let height = 30.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = false
        $0.backgroundColor = .white
    }

    private lazy var categoryLabel = UILabel().then {
        $0.text = "유형"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
    }

    private lazy var categoryCollectionView = UICollectionView(frame: .zero,
                                                               collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 20.0
        let width = 111.0
        let height = 30.0

        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets(top: 0.0, left: 20.0, bottom: 0.0, right: 0.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing

        $0.collectionViewLayout = layout
        $0.register(FilterCell.self, forCellWithReuseIdentifier: FilterCell.identyfier)
        $0.showsHorizontalScrollIndicator = false
        $0.bounces = false
        $0.isPagingEnabled = false
        $0.backgroundColor = .white
    }

    private lazy var resetButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .bold)
    }

    private lazy var searchButton = UIButton().then {
        $0.backgroundColor = .black
        $0.setTitle("적용", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .bold)
    }
    
    private lazy var marginSearchButton = UIButton().then {
        $0.backgroundColor = .black
    }

    private let bag = DisposeBag()
    var viewHeight = 600.0
    var befViewModel: PlaceListViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: FilterViewModel) {
        // MARK: Todo. collectionViewModel, cellViewModel 역할 분담

        // MARK: view -> viewModel

        regionCollectionView.rx.modelSelected(FilterCellModel.self)
            .bind(to: viewModel.selectedRegion)
            .disposed(by: bag)

        categoryCollectionView.rx.modelSelected(FilterCellModel.self)
            .bind(to: viewModel.selectedCategory)
            .disposed(by: bag)

        plusButton.rx.tap
            .bind(to: viewModel.plusButtonTapped)
            .disposed(by: bag)

        minusButton.rx.tap
            .bind(to: viewModel.minusButtonTapped)
            .disposed(by: bag)

        petButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.petButtonTapped)
            .disposed(by: bag)

        resetButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.resetButtonTapped)
            .disposed(by: bag)

        Observable.merge(
            searchButton.rx.tap.map { _ in () },
            marginSearchButton.rx.tap.map { _ in () }
            )
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.setPerssonel
            .drive(personnelNumberLabel.rx.text)
            .disposed(by: bag)

        viewModel.setSelectedButtonType
            .drive(onNext: {
                self.minusButton.setTitleColor($0 == .minus ? .white : .black, for: .normal)
                self.minusButton.backgroundColor = $0 == .minus ? .black : .white
                self.plusButton.setTitleColor($0 == .plus ? .white : .black, for: .normal)
                self.plusButton.backgroundColor = $0 == .plus ? .black : .white
            })
            .disposed(by: bag)

        viewModel.setPet
            .drive(onNext: {
                if $0 {
                    self.petButton.backgroundColor = .black
                    self.petButton.setTitleColor(.white, for: .normal)
                } else {
                    self.petButton.backgroundColor = .white
                    self.petButton.setTitleColor(.black, for: .normal)
                }
            })
            .disposed(by: bag)

        viewModel.regions
            .drive(regionCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: FilterCell.identyfier, for: IndexPath(row: idx, section: 0)) as? FilterCell else { return UICollectionViewCell() }
                let FilterCellVM = FilterCellViewModel(data)
                cell.bind(FilterCellVM)

                viewModel.setRegion
                    .drive(onNext: {
                        if $0.name == data.name {
                            cell.contentView.backgroundColor = .black
                            cell.filterLabel.textColor = .white
                        } else {
                            cell.contentView.backgroundColor = .white
                            cell.filterLabel.textColor = .black
                        }
                    })
                    .disposed(by: cell.bag)

                return cell
            }
            .disposed(by: bag)

        viewModel.categorys
            .drive(categoryCollectionView.rx.items) { col, idx, data in
                guard let cell = col.dequeueReusableCell(withReuseIdentifier: FilterCell.identyfier, for: IndexPath(row: idx, section: 0)) as? FilterCell else { return UICollectionViewCell() }
                let FilterCellVM = FilterCellViewModel(data)
                cell.bind(FilterCellVM)

                viewModel.setCategory
                    .drive(onNext: {
                        if $0.name == data.name {
                            cell.contentView.backgroundColor = .black
                            cell.filterLabel.textColor = .white
                        } else {
                            cell.contentView.backgroundColor = .white
                            cell.filterLabel.textColor = .black
                        }
                    })
                    .disposed(by: cell.bag)
                return cell
            }
            .disposed(by: bag)

        // MARK: scene

        viewModel.pushPlaceListVC
            .emit(onNext: { [weak self] viewModel in
                guard let self = self,
                      let tabbarVC = self.presentingViewController as? UINavigationController else { return }
                let placeListVC = PlaceListViewController()
                placeListVC.bind(viewModel)

                self.dismiss(animated: true, completion: {
                    tabbarVC.pushViewController(placeListVC, animated: true)
                })
            })
            .disposed(by: bag)

        viewModel.popToSearchListVC
            .emit(onNext: { [weak self] filterModel in
                guard let self = self,
                      let befViewModel = self.befViewModel else { return }
                befViewModel.changedSearchFilter.onNext(filterModel)
                self.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)

        cancleButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.roundCorners(corners: [.topLeft, .topRight], radius: 10.0)
        view.backgroundColor = .white
    }

    func layout() {
        [
            minusButton,
            personnelNumberLabel,
            plusButton,
        ].forEach {
            personnelNumberView.addSubview($0)
        }
        minusButton.snp.makeConstraints {
            $0.height.width.equalTo(23.0)
            $0.leading.equalToSuperview().inset(6.0)
            $0.centerY.equalToSuperview()
        }

        personnelNumberLabel.snp.makeConstraints {
            $0.width.equalTo(37.0)
            $0.centerX.centerY.equalToSuperview()
        }

        plusButton.snp.makeConstraints {
            $0.height.width.equalTo(23.0)
            $0.trailing.equalToSuperview().inset(6.0)
            $0.centerY.equalToSuperview()
        }

        [
            titleLabel,
            cancleButton,
            personnelLabel,
            personnelNumberView,
            petButton,
            regionLabel,
            regionCollectionView,
            categoryLabel,
            categoryCollectionView,
            resetButton,
            searchButton,
            marginSearchButton,
        ].forEach {
            view.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(40.0)
            $0.centerX.equalToSuperview()
        }

        cancleButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(30.0)
            $0.height.width.equalTo(30.0)
        }

        personnelLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(30.0)
            $0.top.equalTo(titleLabel.snp.bottom).offset(50.0)
        }

        personnelNumberView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20.0)
            $0.top.equalTo(personnelLabel.snp.bottom).offset(19.0)
            $0.width.equalTo(111.0)
            $0.height.equalTo(33.0)
        }

        petButton.snp.makeConstraints {
            $0.leading.equalTo(personnelNumberView.snp.trailing).offset(20.0)
            $0.top.equalTo(personnelNumberView.snp.top)
            $0.width.equalTo(111.0)
            $0.height.equalTo(33.0)
        }

        regionLabel.snp.makeConstraints {
            $0.leading.equalTo(personnelLabel)
            $0.top.equalTo(personnelNumberView.snp.bottom).offset(40.0)
        }

        regionCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(regionLabel.snp.bottom).offset(19.0)
            $0.height.equalTo(33.0 * 2 + 16.0)
        }

        categoryLabel.snp.makeConstraints {
            $0.leading.equalTo(personnelLabel)
            $0.top.equalTo(regionCollectionView.snp.bottom).offset(40.0)
        }

        categoryCollectionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryLabel.snp.bottom).offset(19.0)
            $0.height.equalTo(33.0)
        }

        resetButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(categoryCollectionView.snp.bottom)
            $0.height.equalTo(87.0)
        }

        searchButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(resetButton.snp.bottom)
            $0.height.equalTo(54.0)
        }
        
        marginSearchButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(searchButton.snp.bottom)
            $0.bottom.equalToSuperview()
        }
    }
}
