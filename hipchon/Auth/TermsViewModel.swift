//
//  TermsViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/21.
//

import RxCocoa
import RxRelay
import RxSwift

class TermsViewModel {
    private let bag = DisposeBag()
    
    // MARK: viewModel -> view
    
    let pushEditProfileVC: Signal<EditProfileViewModel>
    let setEntireAgree: Driver<Bool>
    let setAgeAgree: Driver<Bool>
    let setServiceAgree: Driver<Bool>
    let setPrivacyAgree: Driver<Bool>
    let setPositionAgree: Driver<Bool>
    let setMaketingAgree: Driver<Bool>
    
    // MARK: view -> viewModel
    
    let entireCheckButtonTapped = PublishRelay<Void>()
    let ageCheckButtonTapped = PublishRelay<Void>()
    let serviceCheckButtonTapped = PublishRelay<Void>()
    let privacyCheckButtonTapped = PublishRelay<Void>()
    let positionCheckButtonTapped = PublishRelay<Void>()
    let maketingCheckButtonTapped = PublishRelay<Void>()
    let completeButtonTapped = PublishRelay<Void>()
    
    init(_ data: AuthModel) {
        let authModel = BehaviorSubject<AuthModel>(value: data)
        let entireAgree = BehaviorSubject<Bool>(value: false)
        let ageAgree = BehaviorSubject<Bool>(value: false)
        let serviceAgree = BehaviorSubject<Bool>(value: false)
        let privacyAgree = BehaviorSubject<Bool>(value: false)
        let positionAgree = BehaviorSubject<Bool>(value: false)
        let maketingAgree = BehaviorSubject<Bool>(value: false)
        
        setEntireAgree = entireAgree
            .asDriver(onErrorJustReturn: false)
        
        setAgeAgree = ageAgree
            .asDriver(onErrorJustReturn: false)
        
        setServiceAgree = serviceAgree
            .asDriver(onErrorJustReturn: false)
        
        setPrivacyAgree = privacyAgree
            .asDriver(onErrorJustReturn: false)
        
        setPositionAgree = positionAgree
            .asDriver(onErrorJustReturn: false)
        
        setMaketingAgree = maketingAgree
            .asDriver(onErrorJustReturn: false)
        
        Observable.combineLatest(ageAgree,
                                 serviceAgree,
                                 privacyAgree,
                                 positionAgree,
                                 maketingAgree)
            .map { $0.0 == true && $0.1 == true && $0.2 == true && $0.3 == true && $0.4 == true }
            .bind(to: entireAgree)
            .disposed(by: bag)
        
        entireCheckButtonTapped
            .withLatestFrom(entireAgree) { !$1 }
            .subscribe(onNext: { flag in
                [ageAgree, serviceAgree, privacyAgree, positionAgree, maketingAgree].forEach {
                    $0.onNext(flag)
                }
            })
            .disposed(by: bag)
                            
        ageCheckButtonTapped
            .withLatestFrom(ageAgree)
            .map { !$0 }
            .bind(to: ageAgree)
            .disposed(by: bag)
        
        serviceCheckButtonTapped
            .withLatestFrom(serviceAgree) { !$1 }
            .bind(to: serviceAgree)
            .disposed(by: bag)
        
        privacyCheckButtonTapped
            .withLatestFrom(privacyAgree) { !$1 }
            .bind(to: privacyAgree)
            .disposed(by: bag)
        
        positionCheckButtonTapped
            .withLatestFrom(positionAgree) { !$1 }
            .bind(to: positionAgree)
            .disposed(by: bag)
        
        maketingCheckButtonTapped
            .withLatestFrom(maketingAgree) { !$1 }
            .bind(to: maketingAgree)
            .disposed(by: bag)
            
        
        pushEditProfileVC = completeButtonTapped
            .withLatestFrom(Observable.combineLatest(authModel,
                                                     maketingAgree))
            .map { auth, maketing in
                auth.maketingAgree = maketing
                return auth
            }
            .map { EditProfileViewModel($0) }
            .asSignal(onErrorSignalWith: .empty())
        
        
    }
}
