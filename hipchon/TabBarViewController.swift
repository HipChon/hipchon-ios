//
//  TabBarViewController.swift
//  hipchon
//
//  Created by 김범수 on 2022/02/03.
//

import UIKit

class TabBarViewController: UITabBarController {
    let homeViewModel = HomeViewModel()
    let feedViewModel = FeedViewModel()
    let profileViewModel = ProfileViewModel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "홈",
                                                     image: UIImage(named: "home") ?? UIImage(),
                                                     selectedImage: UIImage(named: "home_fill") ?? UIImage())
        homeViewController.bind(homeViewModel)

        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "피드",
                                                     image: UIImage(named: "feed") ?? UIImage(),
                                                     selectedImage: UIImage(named: "feed_fill") ?? UIImage())
        feedViewController.bind(feedViewModel)

        let storagePlaceViewController = StoragePlaceViewController()
        storagePlaceViewController.tabBarItem = UITabBarItem(title: "저장",
                                                             image: UIImage(named: "bookmark") ?? UIImage(),
                                                             selectedImage: UIImage(named: "bookmark_fill") ?? UIImage())

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "프로필",
                                                        image: UIImage(named: "profile") ?? UIImage(),
                                                        selectedImage: UIImage(named: "profile_fill") ?? UIImage())
        profileViewController.bind(profileViewModel)

        [
            homeViewController,
            feedViewController,
            storagePlaceViewController,
            profileViewController,
        ].forEach {
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
            $0.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
            $0.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray04], for: .normal)
            $0.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .focused)
            $0.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .highlighted)
        }

        view.backgroundColor = .white
        tabBar.backgroundColor = .white
        tabBar.tintColor = .black

        let boundaryView = UIView(frame: CGRect(x: tabBar.frame.minX,
                                                y: tabBar.frame.minY,
                                                width: tabBar.frame.width,
                                                height: 1))
        boundaryView.backgroundColor = UIColor.lightGray
        tabBar.addSubview(boundaryView)

        viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: storagePlaceViewController),
            UINavigationController(rootViewController: profileViewController),
        ]
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }
}
