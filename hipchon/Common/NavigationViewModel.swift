//
//  NavigationViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/11.
//

import RxCocoa
import RxRelay

class NavigationViewModel {
    
    let pop: Signal<Void>
    
    let backButtonTapped = PublishRelay<Void>()
    
    init() {
        pop = backButtonTapped
            .asSignal()
    }
}
