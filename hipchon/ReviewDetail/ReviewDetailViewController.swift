//
//  ReviewDetailViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/08.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class ReviewDetailViewController: UIViewController {
    // MARK: Property

    private lazy var navigationView = NavigationView().then { _ in
    }

    private lazy var commentTableView = UITableView(frame: .zero, style: .grouped).then {
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
        $0.register(ReviewDetailHeaderView.self, forHeaderFooterViewReuseIdentifier: ReviewDetailHeaderView.identyfier)
        $0.register(CommentCell.self, forCellReuseIdentifier: CommentCell.identyfier)
        $0.estimatedRowHeight = 120.0
        $0.showsVerticalScrollIndicator = false
        $0.separatorStyle = .none
        $0.isScrollEnabled = true
    }

    private lazy var inputCommentView = InputCommentView().then { _ in
    }

    private let bag = DisposeBag()
    var viewModel: ReviewDetailViewModel?

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: ReviewDetailViewModel) {
        self.viewModel = viewModel

        if let inputCommentVM = viewModel.inputCommentVM {
            inputCommentView.bind(inputCommentVM)
        }

        viewModel.reloadData
            .emit(onNext: { [weak self] in
                self?.commentTableView.reloadData()
            })
            .disposed(by: bag)
    }

    func attribute() {
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        addKeyboardNotification()
    }

    func layout() {
        // MARK: scroll

        [
            navigationView,
            commentTableView,
            inputCommentView,
        ].forEach {
            view.addSubview($0)
        }

        navigationView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(navigationView.viewHeight)
        }

        commentTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(inputCommentView.snp.top)
        }

        inputCommentView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(102.0)
        }
    }
}

extension ReviewDetailViewController: UITableViewDelegate, UITableViewDataSource {
    // TableView DataSource

    func numberOfSections(in _: UITableView) -> Int {
        return 1
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return viewModel?.commentVMs.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCell.identyfier) as? CommentCell,
              let viewModel = viewModel
        else {
            return UITableViewCell()
        }
        let cellViewModel = viewModel.commentVMs[indexPath.row]
        cell.bind(cellViewModel)
        return cell
    }

    // Header & Footer

    func tableView(_ tableView: UITableView, viewForHeaderInSection _: Int) -> UIView? {
        guard let viewModel = viewModel?.reviewDetailHeaderVM,
              let headerCell = tableView.dequeueReusableHeaderFooterView(withIdentifier: ReviewDetailHeaderView.identyfier) as? ReviewDetailHeaderView else { return nil }

        headerCell.bind(viewModel)

        return headerCell
    }

//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 0.0
//    }

    func tableView(_: UITableView, estimatedHeightForHeaderInSection _: Int) -> CGFloat {
        return 600.0
    }

    // Select Cell

    func tableView(_: UITableView, didSelectRowAt _: IndexPath) {}
}

private extension ReviewDetailViewController {
    // 입력 시 키보드만큼 뷰 이동
    private func addKeyboardNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            inputCommentView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.height.equalTo(102.0)
                $0.bottom.equalToSuperview().inset(keyboardSize.height)
            }
            
            commentTableView.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.top.equalTo(navigationView.snp.bottom).offset(-keyboardSize.height)
                $0.bottom.equalTo(inputCommentView.snp.top)
            }
        }
    }

    @objc private func keyboardWillHide(_: Notification) {
        inputCommentView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(102.0)
            $0.bottom.equalToSuperview()
        }
        
        commentTableView.snp.remakeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(navigationView.snp.bottom)
            $0.bottom.equalTo(inputCommentView.snp.top)
        }
    }

    // 주변 터치시 키보드 내림
    private func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
