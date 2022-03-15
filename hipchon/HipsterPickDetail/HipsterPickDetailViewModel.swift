//
//  HipsterPickDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/02.
//

import RxCocoa
import RxRelay
import RxSwift

class HipsterPickDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let navigationVM = NavigationViewModel()

    // MARK: viewModel -> view

    let title: Driver<String>
    let hipsterPickDetailCellVMs: Driver<[HipsterPickDetailCellViewModel]>
    let pop: Signal<Void>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()

    init(_ data: LocalHipsterPickModel) {
        let hipsterPicks = BehaviorSubject<[HipsterPickModel]>(value: [])

        title = Driver.just(data.title ?? "")
            .map { "로컬 힙스터 픽 - \($0)" }

        hipsterPickDetailCellVMs = hipsterPicks
            .map { $0.map { HipsterPickDetailCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        viewAppear
            .flatMap { NetworkManager.shared.getHipsterPicks(data.id ?? 0) }
            .asObservable()
            .bind(to: hipsterPicks)
//            .disposed(by: bag)

        pop = navigationVM.pop
    }
}
