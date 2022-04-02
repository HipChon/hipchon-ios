//
//  HomeViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import RxCocoa
import RxSwift

class HomeViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    let homeSearchVM = HomeSearchViewModel()
    let localHipsterPickVM = LocalHipsterPickViewModel()
    let weeklyHipPlaceVM = WeeklyHipPlaceViewModel()
    let bannerPageCountVM = PageCountViewModel()
    let bestReviewVM = BestReviewViewModel()
    let customerServiceVM = CustomerServiceViewModel()

    // MARK: viewModel -> view

    let hashtags: Driver<[HashtagModel]>
    let banners: Driver<[BannerModel]>
    let pushPlaceListVC: Signal<PlaceListViewModel>
    let presentFilterVC: Signal<FilterViewModel>
    let openURL: Signal<URL>
    let pushPlaceDetailVC: Signal<PlaceDetailViewModel>
    let pushHipsterPickDetailVC: Signal<HipsterPickDetailViewModel>

    // MARK: view -> viewModel

    let selectedHashtag = PublishRelay<HashtagModel>()
    let selectedBanner = PublishRelay<BannerModel>()
    let bannerCurrentIdx = BehaviorRelay<Int>(value: 1)

    init() {

        hashtags = Driver.just(HashtagModel.model)

        pushPlaceListVC = selectedHashtag
            .map { SearchFilterModel(hashtag: $0) }
            .map { PlaceListViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        
        // MARK: banner
        
        let bannerData = BehaviorSubject<[BannerModel]>(value: [])
        
        Observable.just(())
            .filter { DeviceManager.shared.networkStatus }
            .flatMap { _ in ElseAPI.shared.getBanners() }
            .subscribe(on: ConcurrentDispatchQueueScheduler(queue: .global()))
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { result in
                switch result {
                case .success(let data):
                    bannerData.onNext(data)
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // 401: unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // 13: Timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
//                        Singleton.shared.unknownedError.onNext(error) // TODO:
                        break
                    }
                }
            })
            .disposed(by: bag)
        
        banners = bannerData
            .asDriver(onErrorJustReturn: [])

        bannerData
            .map { $0.count }
            .asObservable()
            .bind(to: bannerPageCountVM.entireIdx)
            .disposed(by: bag)

        bannerCurrentIdx
            .map { $0 + 1 }
            .bind(to: bannerPageCountVM.currentIdx)
            .disposed(by: bag)

        // MARK: scene

        presentFilterVC = homeSearchVM.searchButtonTapped
            .map { FilterViewModel(.search) }
            .asSignal(onErrorSignalWith: .empty())

        openURL = Observable.merge(
            selectedBanner.compactMap { $0.linkURL },
            customerServiceVM.selectedURLStr
        )
        .compactMap { URL(string: $0) }
        .asSignal(onErrorSignalWith: .empty())

        pushPlaceDetailVC = weeklyHipPlaceVM.selectedHipPlace
            .map { PlaceDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())

        pushHipsterPickDetailVC = localHipsterPickVM.selectedLocalHipsterPick
            .map { HipsterPickDetailViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
    }
}
