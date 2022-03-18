//
//  TopTabViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/18.
//

import UIKit
import Tabman
import Pageboy

class StoragePlaceViewController: TabmanViewController {
    
    private lazy var storageLabel = UILabel().then {
        $0.text = "저장"
        $0.font = .GmarketSans(size: 24.0, type: .medium)
    }
    
    private lazy var sortButton = UIButton().then {
        $0.setImage(UIImage(named: "sort") ?? UIImage(), for: .normal)
    }
    
    private lazy var topBarPositionView = UIView().then { _ in
    }
    
    private lazy var borderView = UIView().then {
        $0.backgroundColor = .gray_border
    }

    private lazy var viewControllers: [UIViewController] = {
        let entirePlaceVC = SectorPlaceViewController()
        entirePlaceVC.bind(SectorPlaceViewModel(.entire))
        let cafePlaceVC = SectorPlaceViewController()
        cafePlaceVC.bind(SectorPlaceViewModel(.cafe))
        let foodPlaceVC = SectorPlaceViewController()
        foodPlaceVC.bind(SectorPlaceViewModel(.food))
        let activityPlaceVC = SectorPlaceViewController()
        activityPlaceVC.bind(SectorPlaceViewModel(.activity))
        let naturalPlaceVC = SectorPlaceViewController()
        naturalPlaceVC.bind(SectorPlaceViewModel(.natural))
        return [entirePlaceVC, cafePlaceVC, foodPlaceVC, activityPlaceVC, naturalPlaceVC]
    }()
    
    private lazy var topBar = TMBar.ButtonBar().then { bar in
        bar.backgroundView.style = .blur(style: .regular)
        bar.layout.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        bar.buttons.customize { (button) in
            button.tintColor = .gray03
            button.selectedTintColor = .black
            button.selectedFont = .GmarketSans(size: 16.0, type: .medium)
        }
        // 인디케이터 조정
        bar.indicator.weight = .medium
        bar.indicator.tintColor = .black
        bar.indicator.overscrollBehavior = .compress
        bar.layout.alignment = .centerDistributed
        bar.layout.contentMode = .fit
        bar.layout.interButtonSpacing = 0
        bar.backgroundColor = .white
    
        bar.layout.transitionStyle = .progressive
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        layout()
        setTopBar()
    }
    
    private func attribute() {
        view.backgroundColor = .white
    }
    
    private func layout() {
        [
            storageLabel,
            sortButton,
            topBarPositionView,
            borderView,
        ].forEach {
            view.addSubview($0)
        }
        
        storageLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(18.0)
            $0.leading.equalToSuperview().inset(35.0)
            $0.height.equalTo(25.0)
        }
        
        sortButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(26.0)
            $0.centerY.equalTo(storageLabel)
            $0.width.height.equalTo(15.0)
        }
        
        topBarPositionView.snp.makeConstraints {
            $0.top.equalTo(storageLabel.snp.bottom).offset(28.0)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(50.0)
        }
        
        borderView.snp.makeConstraints {
            $0.leading.bottom.trailing.equalTo(topBarPositionView)
            $0.height.equalTo(1.0)
        }
    }
    
    private func setTopBar() {
        self.dataSource = self
        addBar(topBar, dataSource: self, at: .custom(view: topBarPositionView, layout: nil))
    }
}

extension StoragePlaceViewController: PageboyViewControllerDataSource, TMBarDataSource {

    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
        return viewControllers.count
    }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        return viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return .at(index: 0)
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        switch index {
        case 0:
            title = "전체"
        case 1:
            title = "카페"
        case 2:
            title = "미식"
        case 3:
            title = "활동"
        case 4:
            title = "자연"
        default:
            title = "기타"
        }
        return TMBarItem(title: title)
    }
}
