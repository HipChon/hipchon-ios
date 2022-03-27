//
//  DeviceManager.swift
//  hipchon
//
//  Created by 김범수 on 2022/03/24.
//

import SystemConfiguration

class DeviceManager {
    static let shared: DeviceManager = .init()

    var networkStatus: Bool {
        return checkDeviceNetworkStatus()
    }

    private init() {}

    private func checkDeviceNetworkStatus() -> Bool {
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)

        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }

        var flags = SCNetworkReachabilityFlags(rawValue: 0)
        if SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) == false {
            Singleton.shared.toastAlert.onNext("네트워크 연결 상태를 확인해주세요")
            return false
        }

        // Working for Cellular and WIFI
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        let ret = (isReachable && !needsConnection)
        if ret == false {
            Singleton.shared.toastAlert.onNext("네트워크 연결 상태를 확인해주세요")
        }
        return ret
    }
}
