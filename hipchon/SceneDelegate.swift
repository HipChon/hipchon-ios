//
//  SceneDelegate.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import KakaoSDKAuth
import UIKit
import SwiftKeychainWrapper

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .white

        
        let autoLogin = KeychainWrapper.standard.string(forKey: "userId") != nil
        
        let onBoardingViewController = OnBoardingViewController()
        let naviagtionController = UINavigationController(rootViewController: onBoardingViewController)
        if KeychainWrapper.standard.string(forKey: "userId") != nil { // 자동 로그인
            let tapBarViewController = TabBarViewController()
            naviagtionController.viewControllers.append(tapBarViewController)
        }
        window?.rootViewController = naviagtionController
        window?.makeKeyAndVisible()
    }

    // MARK: Kakao Redirect Url
    func scene(_: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if AuthApi.isKakaoTalkLoginUrl(url) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }
}
