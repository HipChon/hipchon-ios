//
//  LocalHipsterPickViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxRelay
import RxSwift

class LocalHipsterPickViewModel {
    private let bag = DisposeBag()

    // MARK: viewModel -> view

    let localHipsterPicks: Driver<[LocalHipsterPickModel]>

    // MARK: view -> viewModel

    
    let selectedLocalHipsterPick = PublishRelay<LocalHipsterPickModel>()

    init() {
        let localHipsterPickListData = BehaviorSubject<[LocalHipsterPickModel]>(value: [])
        
        localHipsterPicks = localHipsterPickListData
            .asDriver(onErrorJustReturn: [])
        
         Observable.just(())
            .filter { DeviceManager.shared.networkStatus }
            .flatMap { PlaceAPI.shared.getLocalHipsterPickList() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    localHipsterPickListData.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 404: // 404: Not Found(등록된 리뷰 없음)
                        localHipsterPickListData.onNext([])
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
