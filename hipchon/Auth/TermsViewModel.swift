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

    let setEntireAgree: Driver<Bool>
    let setAgeAgree: Driver<Bool>
    let setServiceAgree: Driver<Bool>
    let setPrivacyAgree: Driver<Bool>
    let setPositionAgree: Driver<Bool>
    let setMaketingAgree: Driver<Bool>
    let completeButtonValid: Driver<Bool>
    let pushEditProfileVC: Signal<EditProfileViewModel>
    let openURL: Signal<URL>

    // MARK: view -> viewModel

    let entireCheckButtonTapped = PublishRelay<Void>()
    let ageCheckButtonTapped = PublishRelay<Void>()
    let serviceCheckButtonTapped = PublishRelay<Void>()
    let serviceButtonTapped = PublishRelay<Void>()
    let privacyCheckButtonTapped = PublishRelay<Void>()
    let privacyButtonTapped = PublishRelay<Void>()
    let positionCheckButtonTapped = PublishRelay<Void>()
    let positionButtonTapped = PublishRelay<Void>()
    let maketingCheckButtonTapped = PublishRelay<Void>()
    let maketingButtonTapped = PublishRelay<Void>()
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

        completeButtonValid = Observable.combineLatest(ageAgree,
                                                       serviceAgree,
                                                       privacyAgree,
                                                       positionAgree)
            .map { $0.0 == true && $0.1 == true && $0.2 == true && $0.3 == true }
            .asDriver(onErrorJustReturn: false)

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

        openURL = Observable.merge(
            serviceButtonTapped.map { "https://frost-kite-c1c.notion.site/156ae780da1d482f92ba93a852e83a27" },
            privacyButtonTapped.map { "https://frost-kite-c1c.notion.site/f6239a9d67784836b69cc4bedfc95a7e" },
            positionButtonTapped.map { "https://frost-kite-c1c.notion.site/8b3cabf85df84515b3e1c23696fdd6e2" },
            maketingButtonTapped.map { "https://frost-kite-c1c.notion.site/da4dd6f059f244ac944a0ae878ef373b" }
        )
        .compactMap { URL(string: $0) }
        .asSignal(onErrorSignalWith: .empty())

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
