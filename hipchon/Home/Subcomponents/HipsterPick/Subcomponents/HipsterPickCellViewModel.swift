//
//  HipsterPickCellViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/16.
//

import RxCocoa
import RxSwift

class HipsterPickCellViewModel {
    
    private let bag = DisposeBag()
    
    // MARK: subViewModels
    let regionLabelVM = RoundLabelViewModel()
    
    // MARK: viewModel -> view

    let imageURL: Driver<URL>
    let title: Driver<String>
    let content: Driver<String>

    // MARK: view -> viewModel

    init(_ data: HipsterPickModel) {
        let hipsterPick = BehaviorSubject<HipsterPickModel>(value: data)
        
        imageURL = hipsterPick
            .compactMap { $0.imageURL }
            .compactMap { URL(string: $0) }
            .asDriver(onErrorDriveWith: .empty())
        
        hipsterPick
            .compactMap { $0.region }
            .bind(to: regionLabelVM.content)
            .disposed(by: bag)
        
        title = hipsterPick
            .compactMap { $0.title }
            .asDriver(onErrorJustReturn: "")
        
        content = hipsterPick
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
    }
}
