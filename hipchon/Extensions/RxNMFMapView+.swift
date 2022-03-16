//
//  RxNMFMapView+.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/05.
//

import NMapsMap
import RxSwift

extension Reactive where Base: NMFMapView {
    var setMapCenterPoint: Binder<NMGLatLng> {
        return Binder(base) { base, point in
            let cameraUpdate = NMFCameraUpdate(scrollTo: point)
            cameraUpdate.animation = .linear
            base.moveCamera(cameraUpdate)
        }
    }
}
