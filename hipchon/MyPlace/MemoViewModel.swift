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
    var befViewModel: MyPlaceCellViewModel?

    // MARK: viewModel -> view

    let content: Driver<String>
    let color: Driver<UIColor>
    let contentCount: Driver<Int>
    let completeButtonValid: Driver<Bool>
    let presentMemoCompleteVC: Signal<Void>

    // MARK: view -> viewModel

    let inputContent = PublishRelay<String>()
    let changedColor = PublishRelay<UIColor>()
    let completeButtonTapped = PublishRelay<Void>()

    init(_ place: BehaviorSubject<PlaceModel>) {
        let memo = place
            .compactMap { $0.memo }
        let memoCoplete = PublishSubject<Void>()

        content = memo
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        color = Observable.merge( Observable.just(.gray01),
                                  memo.map { $0.backgroundColor }.asObservable(),
                                 changedColor.asObservable())
            .asDriver(onErrorJustReturn: .gray01)

        contentCount = inputContent
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)

        completeButtonValid = inputContent
            .map { $0.count > 0 && $0.count <= 30 && $0 != "나만의 메모를 남겨볼까요" }
            .asDriver(onErrorJustReturn: true)

        
        presentMemoCompleteVC = memoCoplete
            .asSignal(onErrorJustReturn: ())
        
        completeButtonTapped
            .withLatestFrom(Observable.combineLatest(place.compactMap { $0.id }, inputContent, color.asObservable()))
            .flatMap { NetworkManager.shared.postMemo(placeId: $0, content: $1, color: $2.memoColorString()) }
            .subscribe(onNext: { _ in
                self.befViewModel?.memoChanged.onNext(())
                memoCoplete.onNext(())
                Singleton.shared.toastAlert.onNext("메모가 등록되었습니다")
            })
            .disposed(by: bag)

    }
}

extension UIColor {
    func memoColorString() -> String {
        switch self {
        case .primary_green:
            return "primary_green"
        case .secondary_yellow:
            return "secondary_yellow"
        case .secondary_blue:
            return "secondary_blue"
        case .secondary_purple:
            return "secondary_purple"
        default:
            return "gray04"
        }
    }
}
