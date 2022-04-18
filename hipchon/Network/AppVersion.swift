//
//  AppVersion.swift
//  hipchon
//
//  Created by 김범수 on 2022/04/18.
//

import UIKit

class AppVersion {
    public static let shared = AppVersion()
    private let appID = "1616878735"
    public var isChecked = false
    private init() {}

    func compareVersion() {
        guard isChecked == false,
              let server = latestVersion(),
              let app = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { return }

        let serverVersion = server.split(separator: ".")
        let appVersion = app.split(separator: ".")

        guard serverVersion.count == 3,
              appVersion.count == 3 else { return }

        // 업데이트 여부 상태 값
        var isUpdate = false

        // Patch, Minor, Major 순으로 비교해야 되기 때문에 reversed를 사용해서 인덱스를 역순으로 변경
        for i in (0 ..< 3).reversed() {
            guard let server = Int(serverVersion[i]), let app = Int(appVersion[i]) else {
                continue
            }

            checkVersion(server: server, app: app, isUpdate: &isUpdate)
        }

        if isUpdate {
            presentUpdateAlert()
        }
        isChecked = true
    }

    func presentUpdateAlert() {
        let appStoreOpenUrlString = "itms-apps://itunes.apple.com/app/apple-store/\(appID)"

        let alert = UIAlertController(title: nil, message:
            "최신 버전으로 업데이트가 가능해요!",
            preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "다음에 할래요", style: .default, handler: nil))

        alert.addAction(UIAlertAction(title: "업데이트", style: UIAlertAction.Style.default, handler: { _ in
            if let url = URL(string: appStoreOpenUrlString),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }))

        guard let topVC = UIApplication.topViewController() else { return }
        topVC.present(alert, animated: true, completion: nil)
    }

    func latestVersion() -> String? {
        guard let url = URL(string: "http://itunes.apple.com/lookup?id=\(appID)"),
              let data = try? Data(contentsOf: url),
              let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
              let results = json["results"] as? [[String: Any]],
              let appStoreVersion = results[0]["version"] as? String
        else {
            return nil
        }
        return appStoreVersion
    }

    func checkVersion(server: Int, app: Int, isUpdate: inout Bool) {
        // 앱 버전이 서버 버전 보다 낮으면 isUpdate = true 변경
        // 앱 버전과 서버 버전이 같으면 isUpdate 변경하지 않음
        // 앱 버전이 서버 보전 보다 높으면 isUpdate = false 변경
        if server == app {
        } else if server > app {
            isUpdate = true
        } else if server < app {
            isUpdate = false
        }
    }
}
