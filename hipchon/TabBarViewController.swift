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
    let myPlaceViewModel = MyPlaceViewModel()
    let profileViewModel = ProfileViewModel()

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        let homeViewController = HomeViewController()
        homeViewController.tabBarItem = UITabBarItem(title: "홈",
                                                     image: UIImage(systemName: "list.bullet"),
                                                     selectedImage: UIImage(systemName: "list.bullet"))
        homeViewController.bind(homeViewModel)

        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "피드",
                                                     image: UIImage(systemName: "list.bullet"),
                                                     selectedImage: UIImage(systemName: "list.bullet"))
        feedViewController.bind(feedViewModel)

        let myPlaceViewController = MyPlaceViewController()
        myPlaceViewController.tabBarItem = UITabBarItem(title: "장소",
                                                        image: UIImage(systemName: "list.bullet"),
                                                        selectedImage: UIImage(systemName: "list.bullet"))
        myPlaceViewController.bind(myPlaceViewModel)

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "프로필",
                                                        image: UIImage(systemName: "person"),
                                                        selectedImage: UIImage(systemName: "person.fill"))
        profileViewController.bind(profileViewModel)

        [homeViewController,
         profileViewController].forEach { $0?.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0) }
        view.backgroundColor = .white
        tabBar.backgroundColor = .white

        let boundaryView = UIView(frame: CGRect(x: tabBar.frame.minX,
                                                y: tabBar.frame.minY,
                                                width: tabBar.frame.width,
                                                height: 1))
        boundaryView.backgroundColor = UIColor.lightGray
        tabBar.addSubview(boundaryView)

        viewControllers = [
            UINavigationController(rootViewController: homeViewController),
            UINavigationController(rootViewController: feedViewController),
            UINavigationController(rootViewController: myPlaceViewController),
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
