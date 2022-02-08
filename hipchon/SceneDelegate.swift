//
//  SceneDelegate.swift
//  hipchon
//
//  Created by 김범수 on 2022/01/30.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    let loginViewModel = LoginViewModel()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .systemBackground
        
//        let loginViewController = LoginViewController()
//        loginViewController.bind(loginViewModel)
//        window?.rootViewController = loginViewController
        
        let tapBarViewController = TabBarViewController()
        window?.rootViewController = tapBarViewController

        window?.makeKeyAndVisible()
    }
}
