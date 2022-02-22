//
//  RegisterViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/22.
//

import RxCocoa
import RxSwift

class RegisterViewModel {
    private let bag = DisposeBag()
    
    // MARK: viewModel -> view

    let emailValid: Signal<Bool>
    let passwordValid: Signal<Bool>
    let passwordWrongType: Driver<RegisterPasswordCheckType>
    let registerButtonValid: Driver<Bool>


    // MARK: view -> viewModel

    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    init() {
        
        emailValid = email
            .filter { $0 != "" }
            .map { AuthModel.emailValidCheck(email: $0) }
            .asSignal(onErrorJustReturn: false)
        
        let passwordCheckType = PublishSubject<RegisterPasswordCheckType>()

        passwordValid = password
            .filter { $0 != "" }
            .map { AuthModel.registerPasswordValidCheck(password: $0) }
            .map { $0 == .right }
            .asSignal(onErrorJustReturn: false)

        passwordWrongType = password
            .map { AuthModel.registerPasswordValidCheck(password: $0) }
            .asDriver(onErrorJustReturn: .right)
     
        registerButtonValid = Observable.combineLatest(emailValid.asObservable(),
                                                       passwordValid.asObservable())
            .map { $0 == true && $1 == true }
            .asDriver(onErrorJustReturn: false)
        
    }
    
}
