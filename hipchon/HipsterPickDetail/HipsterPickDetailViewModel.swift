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

    // MARK: viewModel -> view

    let title: Driver<String>
    let hipsterPickDetailCellVMs: Driver<[HipsterPickDetailCellViewModel]>

    // MARK: view -> viewModel

    let viewAppear = PublishRelay<Void>()

    init(_ data: LocalHipsterPickModel) {
        let localHipsterPickData = BehaviorSubject<LocalHipsterPickModel>(value: data)
        let hipsterPickDatas = BehaviorSubject<[HipsterPickModel]>(value: [])

        title = localHipsterPickData
            .compactMap { $0.title }
            .asDriver(onErrorJustReturn: "")

        hipsterPickDetailCellVMs = hipsterPickDatas
            .map { $0.map { HipsterPickDetailCellViewModel($0) } }
            .asDriver(onErrorJustReturn: [])

        localHipsterPickData
            .compactMap { $0.hipsterPicks }
            .bind(to: hipsterPickDatas)
            .disposed(by: bag)

        Observable.just(())
            .filter { DeviceManager.shared.networkStatus }
            .withLatestFrom(localHipsterPickData)
            .compactMap { $0.id }
            .flatMap { PlaceAPI.shared.getLocalHipsterPickDetail(id: $0) }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case let .success(data):
                    localHipsterPickData.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        break
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
    }
}
