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


    // MARK: view -> viewModel

    let email = BehaviorRelay<String>(value: "")
    let password = BehaviorRelay<String>(value: "")
    
    init() {
        
        emailValid = email
            .filter { $0 != "" }
            .map { AuthModel.emailValidCheck(email: $0) }
            .asSignal(onErrorJustReturn: false)
        
        let passwordCheckType = PublishSubject<RegisterPasswordCheckType>()
        
        password
            .filter { $0 != "" }
           .map { AuthModel.registerPasswordValidCheck(password: $0) }
           .bind(to: passwordCheckType)
           .disposed(by: bag)
        
        passwordValid = passwordCheckType
            .map { $0 == .right }
            .asSignal(onErrorJustReturn: false)

        passwordWrongType = passwordCheckType
            .asDriver(onErrorJustReturn: .right)
        
        password
            .subscribe(onNext: {
                print($0)
            })
        
        passwordCheckType
            .subscribe(onNext: {
                print($0)
            })
        
    }
    
}
