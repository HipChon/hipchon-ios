//
//  PlaceMapView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import RxSwift
import UIKit

class PlaceMapView: UIView {
    private lazy var mapLabelImageView = UIImageView().then {
        $0.image = UIImage(named: "map") ?? UIImage()
    }

    private lazy var mapLabel = UILabel().then {
        $0.text = "지도"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }
    
    private lazy var mapView = MTMapView().then {
        $0.delegate = self
    }

    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .gray05
    }

    private lazy var copyButton = UIButton().then {
        $0.setTitleColor(.primary_green, for: .normal)
        $0.setTitle("복사", for: .normal)
        $0.titleLabel?.font = .AppleSDGothicNeo(size: 16.0, type: .regular)
    }

    private let bag = DisposeBag()

    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ viewModel: PlaceMapViewModel) {
        // MARK: view -> viewModel

        copyButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .bind(to: viewModel.copyButtonTapped)
            .disposed(by: bag)

        // MARK: viewModel -> view

        viewModel.setAddress
            .drive(addressLabel.rx.text)
            .disposed(by: bag)
        
        viewModel.setMapCenter
            .drive(mapView.rx.setMapCenterPoint)
            .disposed(by: bag)

        viewModel.setMapCenter
            .drive(mapView.rx.addPOIItem)
            .disposed(by: bag)
    }

    private func attribute() {}

    private func layout() {
        [
            mapLabelImageView,
            mapLabel,
            mapView,
            addressLabel,
            copyButton,
        ].forEach {
            addSubview($0)
        }

        mapLabelImageView.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(20.0)
            $0.height.equalTo(25.0)
        }

        mapLabel.snp.makeConstraints {
            $0.leading.equalTo(mapLabelImageView.snp.trailing).offset(8.0)
            $0.centerY.equalTo(mapLabelImageView)
        }

        mapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(mapLabelImageView.snp.bottom).offset(15.0)
            $0.height.equalTo(160.0)
        }

        addressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23.0)
            $0.trailing.equalTo(copyButton.snp.leading).offset(10.0)
            $0.top.equalTo(mapView.snp.bottom).offset(23.0)
        }

        copyButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(22.0)
            $0.centerY.equalTo(addressLabel)
            $0.height.equalTo(18.0)
            $0.width.equalTo(28.0)
        }
    }
}


extension PlaceMapView: MTMapViewDelegate {
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
//        #if DEBUG
//        viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
//        #else
//         viewModel.currentLocation.accept(location)
//        #endif
    }
    
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
//        viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
//        viewModel.poiItemTapped.accept(Void())
        return false
    }
    
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
//        viewModel.mapViewError.accept(error.localizedDescription)
    }
}

extension Reactive where Base: MTMapView {
    var setMapCenterPoint: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            base.setMapCenter(point, animated: true)
        }
    }
    var addPOIItem: Binder<MTMapPoint> {
        return Binder(base) { base, point in
            let mapPOIItem = MTMapPOIItem()
            mapPOIItem.mapPoint = point

            mapPOIItem.showAnimationType = .noAnimation

            mapPOIItem.markerType = .customImage
            mapPOIItem.customImage = UIImage(named: "marker") ?? UIImage()
         
            base.removeAllPOIItems()
            base.addPOIItems([mapPOIItem])
        }
    }

}
