//
//  PlaceMapView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import UIKit
import RxSwift
import NMapsMap

class PlaceMapView: UIView {
    
    private lazy var mapLabel = UILabel().then {
        $0.text = "지도"
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .black
    }
    
    private lazy var mapView = NMFMapView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var addressLabel = UILabel().then {
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .gray05
    }
    
    private let bag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: PlaceMapViewModel) {
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
    
    private func attribute() {
        
    }
    
    private func layout() {
        [
            mapLabel,
            mapView,
            addressLabel
        ].forEach {
            addSubview($0)
        }
        
        mapLabel.snp.makeConstraints {
            $0.leading.top.equalToSuperview().inset(23.0)
        }
        
        mapView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(20.0)
            $0.top.equalTo(mapLabel.snp.bottom).offset(18.0)
            $0.height.equalTo(160.0)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(23.0)
            $0.top.equalTo(mapView.snp.bottom).offset(23.0)
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
        marker.mapView = self.mapView
    }
    
    
}
