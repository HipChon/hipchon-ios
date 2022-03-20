//
//  SceneDelegate.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let loginViewModel = LoginViewModel()
    
    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground

        let onBoardingViewController = OnBoardingViewController()
        window?.rootViewController = UINavigationController(rootViewController: onBoardingViewController)

//        let tapBarViewController = TabBarViewController()
//        window?.rootViewController = UINavigationController(rootViewController: tapBarViewController)

        window?.makeKeyAndVisible()
    }
    
    // Kakao
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
          if let url = URLContexts.first?.url {
              if (AuthApi.isKakaoTalkLoginUrl(url)) {
                  _ = AuthController.handleOpenUrl(url: url)
              }
          }
      }
}
