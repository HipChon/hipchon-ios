//
//  SettingViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/13.
//

import RxCocoa
import RxSwift

class SettingViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view
    let popToOnBoarding: Signal<Void>
    
    // MARK: view -> viewModel
    
    let logoutButtonTapped = PublishRelay<Void>()
    let withdrawButtonTapped = PublishRelay<Void>()
    let partnershipButtonTapped = PublishRelay<Void>()
    let customerServiceButtonTapped = PublishRelay<Void>()
    
    init() {
        let localInfoDeleteComplete = PublishSubject<Void>()
        let localInfoDelete = PublishSubject<Void>()
        
        popToOnBoarding = localInfoDeleteComplete
            .asSignal(onErrorJustReturn: ())
        
        logoutButtonTapped
            .subscribe(onNext: {
                localInfoDelete.onNext(())
            })
            .disposed(by: bag)
        
        withdrawButtonTapped
            .flatMap { AuthManager.shared.withdraw() }
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    localInfoDelete.onNext(())
                case .failure(let error):
                    print(error.description)
                }
            })
            .disposed(by: bag)
        
        localInfoDelete
            .do(onNext: {
                // TODO:  Local Info Delete
            })
            .bind(to: localInfoDeleteComplete)
            .disposed(by: bag)
    }
}
