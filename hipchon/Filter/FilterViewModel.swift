//
//  FilterViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxCocoa
import RxRelay
import RxSwift

enum SelectedButtonType {
    case plus, minus, non
}

class FilterViewModel {
    private let bag = DisposeBag()

    // MARK: subviewModels

    // MARK: viewModel -> view

    let personnels: Driver<[FilterCellModel]>
    let regions: Driver<[FilterCellModel]>
    let categorys: Driver<[FilterCellModel]>
    let setPet: Driver<Bool>
    let setPerssonel: Driver<String>
    let setSelectedButtonType: Driver<SelectedButtonType>
    let setRegion: Driver<FilterCellModel>
    let setCategory: Driver<FilterCellModel>
    let pushPlaceListVC: Signal<PlaceListViewModel>

    // MARK: view -> viewModel

    let findButtonTapped = PublishRelay<Void>()
    let selectedRegion = PublishRelay<FilterCellModel>()
    let selectedCategory = PublishRelay<FilterCellModel>()
    let petButtonTapped = PublishRelay<Void>()
    let plusButtonTapped = PublishRelay<Void>()
    let minusButtonTapped = PublishRelay<Void>()
    let resetButtonTapped = PublishRelay<Void>()
    let searchButtonTapped = PublishRelay<Void>()

    init() {
        personnels = Driver.just(FilterCellModel.tmpModels)
        regions = Driver.just(FilterCellModel.regionModels)
        categorys = Driver.just(FilterCellModel.categoryModels)

        // MARK: 인원 수

        let personnel = BehaviorSubject<Int>(value: 1)

        plusButtonTapped
            .withLatestFrom(personnel)
            .map { min($0 + 1, 9) }
            .bind(to: personnel)
            .disposed(by: bag)

        minusButtonTapped
            .withLatestFrom(personnel)
            .map { max($0 - 1, 1) }
            .bind(to: personnel)
            .disposed(by: bag)

        setPerssonel = personnel
            .map { $0 == 1 ? "나만의" : "\($0)명" }
            .asDriver(onErrorJustReturn: "나만의")

        let selectedButtonType = BehaviorSubject<SelectedButtonType>(value: .non)

        setSelectedButtonType = selectedButtonType
            .asDriver(onErrorJustReturn: .non)

        Observable.merge(
            plusButtonTapped.map { _ in .plus },
            minusButtonTapped.map { _ in .minus }
        )
        .bind(to: selectedButtonType)
        .disposed(by: bag)

        // MARK: 반려동물

        let pet = BehaviorSubject<Bool>(value: false)

        petButtonTapped
            .withLatestFrom(pet)
            .map { !$0 }
            .bind(to: pet)
            .disposed(by: bag)

        setPet = pet
            .asDriver(onErrorJustReturn: false)

        // MARK: 지역

        let region = BehaviorSubject<FilterCellModel>(value: FilterCellModel(name: ""))

        selectedRegion
            .withLatestFrom(Observable.combineLatest(region, selectedRegion))
            .map { $0.name == $1.name ? FilterCellModel(name: "") : $1 }
            .bind(to: region)
            .disposed(by: bag)

        setRegion = region
            .asDriver(onErrorDriveWith: .empty())

        // MARK: 유형

        let category = BehaviorSubject<FilterCellModel>(value: FilterCellModel(name: ""))

        selectedCategory
            .withLatestFrom(Observable.combineLatest(category, selectedCategory))
            .map { $0.name == $1.name ? FilterCellModel(name: "") : $1 }
            .bind(to: category)
            .disposed(by: bag)

        setCategory = category
            .asDriver(onErrorDriveWith: .empty())

        // MARK: 초기화

        resetButtonTapped
            .subscribe(onNext: {
                region.onNext(FilterCellModel(name: ""))
                category.onNext(FilterCellModel(name: ""))
                pet.onNext(false)
                personnel.onNext(1)
                selectedButtonType.onNext(.non)
            })
            .disposed(by: bag)

        // MARK: 검색

        pushPlaceListVC = searchButtonTapped
            .withLatestFrom(Observable.combineLatest(personnel.asObservable(),
                                                     pet.asObservable(),
                                                     region.asObservable(),
                                                     category.asObservable(),
                                                     resultSelector: {
                                                         SearchFilterModel(personnel: $0, pet: $1, region: $2.name, category: $3.name)
                                                     }))
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
