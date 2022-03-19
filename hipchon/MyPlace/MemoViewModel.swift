//
//  MemoViewModel.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/17.
//

import RxCocoa
import RxSwift

class MemoViewModel {
    private let bag = DisposeBag()

    // MARK: subViewModels

    // MARK: viewModel -> view
    let content: Driver<String>
    let color: Driver<UIColor>
    let contentCount: Driver<Int>

    // MARK: view -> viewModel
    
    let inputContent = PublishRelay<String>()
    let changedColor = PublishRelay<UIColor>()

    init(_ data: MemoModel?) {
        let memo = BehaviorSubject<MemoModel>(value: data ?? MemoModel())
        
        content = memo
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")
        
        color = Observable.merge(memo.compactMap { $0.backgroundColor }.asObservable(),
                                 changedColor.asObservable()
                                 )
            .asDriver(onErrorJustReturn: .gray01)
        
        contentCount = inputContent
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)
    }
}
