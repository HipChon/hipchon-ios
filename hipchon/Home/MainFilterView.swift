//
//  MainFilterView.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/31.
//

import RxSwift
import UIKit

class MainFilterView: UIView {
    private let bag = DisposeBag()

    private let positionLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let positionButton: UIButton = {
        let button = UIButton()
        button.setTitle("대한민국 어디서든", for: .normal)
        button.setTitleColor(.black, for: .normal)

        return button
    }()

    private let dateLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let dateButton: UIButton = {
        let button = UIButton()
        button.setTitle("날짜 선택", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.titleLabel?.textAlignment = .left
        return button
    }()

    private let peopleNumLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "heart.fill")
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()

    private let peopleNumButton: UIButton = {
        let button = UIButton()
        button.setTitle("성인 / 어린이 1명", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()

    private let findButton: UIButton = {
        let button = UIButton()
        button.setTitle("숙소 찾기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 12.0
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_: MainFilterViewModel) {}

    private func attribute() {
        backgroundColor = .white
        addShadow(offset: CGSize(width: 2.0, height: 2.0))
        layer.cornerRadius = 10.0
    }

    private func layout() {
        let positionStackView = UIStackView(arrangedSubviews: [positionLogo, positionButton])
        let dateStackView = UIStackView(arrangedSubviews: [dateLogo, dateButton])
        let peopleNumStackView = UIStackView(arrangedSubviews: [peopleNumLogo, peopleNumButton])

        [
            positionStackView,
            dateStackView,
            peopleNumStackView,
        ].forEach { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fill
            stackView.spacing = 8.0
            stackView.snp.makeConstraints {
                $0.height.equalTo(40.0)
            }
        }

        let insetView = UIView()

        let filterStackView = UIStackView(arrangedSubviews: [positionStackView, dateStackView, peopleNumStackView, insetView, findButton])
        filterStackView.axis = .vertical
        filterStackView.distribution = .fillEqually
        filterStackView.spacing = 4.0

        addSubview(filterStackView)

        filterStackView.snp.makeConstraints {
            $0.centerY.centerX.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(12.0)
        }

        [
            positionLogo,
            dateLogo,
            peopleNumLogo,
        ].forEach { logo in
            logo.snp.makeConstraints {
                $0.width.equalTo(logo.snp.height)
            }
        }

        findButton.snp.makeConstraints {
            $0.height.equalTo(findButton.snp.width).multipliedBy(50.0 / 350.0)
        }
    }
}
