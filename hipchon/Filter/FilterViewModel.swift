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

    let personnels: Driver<[FilterModel]>
    let regions: Driver<[FilterModel]>
    let categorys: Driver<[FilterModel]>
    let setPet: Driver<Bool>
    let setPerssonel: Driver<String>
    let selectedButtonType: Driver<SelectedButtonType>

    // MARK: view -> viewModel

    let findButtonTapped = PublishRelay<Void>()
    let selectedRegionIdx = PublishRelay<Int>()
    let selectedCategoryIdx = PublishRelay<Int>()
    let petButtonTapped = PublishRelay<Void>()
    let plusButtonTapped = PublishRelay<Void>()
    let minusButtonTapped = PublishRelay<Void>()

    init() {
        personnels = Driver.just(FilterModel.tmpModels)
        regions = Driver.just(FilterModel.regionModels)
        categorys = Driver.just(FilterModel.categoryModels)

        let pet = BehaviorSubject<Bool>(value: false)

        petButtonTapped
            .withLatestFrom(pet)
            .map { !$0 }
            .bind(to: pet)
            .disposed(by: bag)

        setPet = pet
            .asDriver(onErrorJustReturn: false)

        let personnel = BehaviorSubject<Int>(value: 1)

        plusButtonTapped
            .withLatestFrom(personnel)
            .map { min($0 + 1, 6) }
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

        selectedButtonType = Observable.merge(
            plusButtonTapped.map { _ in .plus },
            minusButtonTapped.map { _ in .minus }
        )
        .asDriver(onErrorJustReturn: .non)
    }
}
