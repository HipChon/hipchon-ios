//
//  PlaceDetailViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift

class PlaceDetailViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels
    let placeDesVM = PlaceDesViewModel()
    let placeMapVM = PlaceMapViewModel()

    // MARK: viewModel -> view

    let urls: Driver<[URL]>
    let openURL: Signal<URL>

    // MARK: view -> viewModel

    init(_ data: PlaceModel) {
        let place = BehaviorSubject<PlaceModel>(value: data)
        

        
       
        urls = place
            .compactMap { $0.imageURLs?.compactMap { URL(string: $0) } }
            .asDriver(onErrorJustReturn: [])
        
        place
            .compactMap { $0.name }
            .bind(to: placeDesVM.placeName)
            .disposed(by: bag)
        
        place
            .compactMap { $0.reviewCount }
            .bind(to: placeDesVM.reviewCount)
            .disposed(by: bag)
        
        place
            .compactMap { $0.bookmarkCount }
            .bind(to: placeDesVM.bookmarkCount)
            .disposed(by: bag)
        
        place
            .compactMap { $0.sector }
            .bind(to: placeDesVM.sector)
            .disposed(by: bag)
        
        place
            .compactMap { $0.businessHours }
            .bind(to: placeDesVM.businessHours)
            .disposed(by: bag)
        
        place
            .compactMap { $0.description }
            .bind(to: placeDesVM.description)
            .disposed(by: bag)
        
        place
            .compactMap { $0.link }
            .bind(to: placeDesVM.link)
            .disposed(by: bag)
        
        place
            .compactMap { $0.address }
            .bind(to: placeMapVM.address)
            .disposed(by: bag)
        
        place
            .take(1)
            .compactMap { $0.id }
            .flatMap { NetworkManager.shared.getPlaceDetail($0) }
            .asObservable()
            .subscribe(onNext: {
                place.onNext($0)
            })
            .disposed(by: bag)
        
        
        openURL = placeDesVM.linkButtonTapped
            .withLatestFrom(place)
            .compactMap { $0.link }
            .compactMap { URL(string: $0) }
            .asSignal(onErrorSignalWith: .empty())
            
    }
}
