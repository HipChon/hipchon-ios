//
//  PlaceMapView.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/03.
//

import UIKit
import RxSwift

class PlaceMapView: UIView {
    
    private lazy var mapLabel = UILabel().then {
        $0.text = "지도"
        $0.font = .AppleSDGothicNeo(size: 16.0, type: .medium)
        $0.textColor = .black
    }
    
    private lazy var mapView = UIView().then {
        $0.backgroundColor = .gray05
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
    
    
}
