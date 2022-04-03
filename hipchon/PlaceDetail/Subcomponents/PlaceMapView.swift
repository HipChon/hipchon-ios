//
//  PlaceMapView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import NMapsMap
import RxSwift
import UIKit

class PlaceMapView: UIView, NMFMapViewCameraDelegate, NMFMapViewOptionDelegate, NMFMapViewTouchDelegate {
    private lazy var mapLabelImageView = UIImageView().then {
        $0.image = UIImage(named: "map") ?? UIImage()
    }

    private lazy var mapLabel = UILabel().then {
        $0.text = "지도"
        $0.font = .GmarketSans(size: 18.0, type: .medium)
        $0.textColor = .black
    }

    private lazy var mapView = NMFMapView(frame: CGRect(x: 0.0,
                                                        y: 0.0,
                                                        width: UIApplication.shared.windows.first?.frame.width ?? 0.0 - 40.0,
                                                        height: 140.0)).then {
        // Delegate
        $0.addCameraDelegate(delegate: self)
        $0.touchDelegate = self
        $0.removeOptionDelegate(delegate: self)

        // Current Position
        $0.positionMode = .direction

        // Zoom and Scroll
        $0.minZoomLevel = 5.0
        $0.maxZoomLevel = 10.0
        $0.allowsZooming = true
        $0.allowsScrolling = true
        $0.allowsTilting = false
        $0.allowsRotating = false

        $0.isUserInteractionEnabled = false
        $0.zoomLevel = 9.5

        // Map display Info
        $0.setLayerGroup(NMF_LAYER_GROUP_BUILDING, isEnabled: true)
        $0.setLayerGroup(NMF_LAYER_GROUP_TRANSIT, isEnabled: true)

        // 한반도 이내
        $0.extent = NMGLatLngBounds(southWestLat: 31.43, southWestLng: 122.37, northEastLat: 44.35, northEastLng: 132)
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

        viewModel.setNMGLatLng
            .drive(mapView.rx.setMapCenterPoint)
            .disposed(by: bag)

        viewModel.setNMGLatLng
            .drive(onNext: { [weak self] in
                self?.addMarker($0)
            })
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

    private func addMarker(_ geoLocation: NMGLatLng) {
        let marker = NMFMarker(position: geoLocation)

//        marker.iconImage = NMFOverlayImage(image: UIImage(named: "nonSelectedMarker")!)

//        marker.touchHandler = { [weak self] (_: NMFOverlay) -> Bool in
//            guard let self = self else { return false }
//            if let selectedMarker = self.selectedMarker {
//                selectedMarker.iconImage = NMFOverlayImage(image: UIImage(named: "nonSelectedMarker")!)
//            }
//            marker.iconImage = NMFOverlayImage(image: UIImage(named: "selectedMarker")!)
//
//            self.selectedMarker = marker
//            self.viewModel.selectedStation.accept(station)
//            return true
//        }
        marker.iconImage = NMFOverlayImage(image: UIImage(named: "marker") ?? UIImage())
        marker.mapView = mapView
    }
}
