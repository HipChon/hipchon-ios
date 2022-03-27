//
//  BottomButton.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/23.
//

import UIKit

class BottomButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func attribute() {
        layer.cornerRadius = 5.0
        layer.masksToBounds = true
        setTitleColor(.white, for: .normal)
        setTitleColor(.gray02, for: .disabled)
        setBackgroundColor(.black, for: .normal)
        setBackgroundColor(.gray01, for: .disabled)
        titleLabel?.font = .AppleSDGothicNeo(size: 18.0, type: .medium)
    }

    // MARK: Activity Indicator

    private var originalButtonText: String?
    var activityIndicator: UIActivityIndicatorView!

    func showLoading() {
        originalButtonText = titleLabel?.text
        isEnabled = false
        setTitle("", for: .disabled)

        if activityIndicator == nil {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        isEnabled = true
        setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        let xCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: activityIndicator, attribute: .centerX, multiplier: 1, constant: 0)
        addConstraint(xCenterConstraint)

        let yCenterConstraint = NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: activityIndicator, attribute: .centerY, multiplier: 1, constant: 0)
        addConstraint(yCenterConstraint)
    }
}
