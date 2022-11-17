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

    init(_ place: BehaviorSubject<Place>) {
        
        let memo = BehaviorSubject<Memo>(value: Memo())
        let memoComplete = PublishSubject<Void>()
        
        place
            .compactMap { $0.memo }
            .bind(to: memo)
            .disposed(by: bag)
        
        inputContent
            .skip(1) // "나만의 메모를 남겨볼까요"
            .distinctUntilChanged()
            .withLatestFrom(memo) { Memo(content: $0, color: $1.color ?? "") }
            .bind(to: memo)
            .disposed(by: bag)
                                     
                                     
        changedColor
            .distinctUntilChanged()
            .withLatestFrom(memo) { Memo(content: $1.content ?? "나만의 메모를 남겨볼까요", color: $0.memoColorString()) }
            .bind(to: memo)
            .disposed(by: bag)
        

        content = memo
            .compactMap { $0.content }
            .asDriver(onErrorJustReturn: "")

        color = memo
            .compactMap { $0.backgroundColor }
            .asDriver(onErrorJustReturn: .gray01)

        contentCount = content
            .map { $0.count }
            .asDriver(onErrorJustReturn: 0)

        completeButtonValid = content
            .map { $0.count > 0 && $0.count <= 30 }
            .asDriver(onErrorJustReturn: true)

        completeButtonTapped
            .filter { DeviceManager.shared.networkStatus }
            .do(onNext: { LoadingIndicator.showLoading() })
            .withLatestFrom(Observable.combineLatest(place.compactMap { $0.id }, inputContent, color.asObservable()))
            .map { ($0.0, Memo(content: $0.1, color: $0.2.memoColorString())) }
            .flatMap { PlaceAPI.shared.postMemo(placeId: $0.0, memo: $0.1) }
            .do(onNext: { _ in LoadingIndicator.hideLoading() })
            .subscribe(onNext: { result in
                switch result {
                case .success:
                    memoComplete.onNext(())
                case let .failure(error):
                    switch error.statusCode {
                    case 401: // unauthorized(토큰 만료)
                        Singleton.shared.unauthorized.onNext(())
                    case 13: // timeout
                        Singleton.shared.toastAlert.onNext("네트워크 환경을 확인해주세요")
                    default:
                        Singleton.shared.unknownedError.onNext(error)
                    }
                }
            })
            .disposed(by: bag)
                
        presentMemoCompleteVC = memoComplete
            .withLatestFrom(Observable.combineLatest(place, memo))
            .do(onNext: { org, memo in
                org.memo = memo
                place.onNext(org)
            })
            .map { _ in () }
            .asSignal(onErrorJustReturn: ())
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
            return "gray01"
        }
    }
}
