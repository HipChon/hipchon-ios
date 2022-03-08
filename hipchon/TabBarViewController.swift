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
                                                     image: UIImage(named: "homeUnselected") ?? UIImage(),
                                                     selectedImage: UIImage(named: "homeSelected") ?? UIImage())
        homeViewController.bind(homeViewModel)

        let feedViewController = FeedViewController()
        feedViewController.tabBarItem = UITabBarItem(title: "피드",
                                                     image: UIImage(named: "feedUnselected") ?? UIImage(),
                                                     selectedImage: UIImage(named: "feedSelected") ?? UIImage())
        feedViewController.bind(feedViewModel)

        let myPlaceViewController = MyPlaceViewController()
        myPlaceViewController.tabBarItem = UITabBarItem(title: "저장",
                                                        image: UIImage(named: "bookmarkUnselected") ?? UIImage(),
                                                        selectedImage: UIImage(named: "bookmarkSelected") ?? UIImage())
        myPlaceViewController.bind(myPlaceViewModel)

        let profileViewController = ProfileViewController()
        profileViewController.tabBarItem = UITabBarItem(title: "프로필",
                                                        image: UIImage(systemName: "person"),
                                                        selectedImage: UIImage(systemName: "person.fill"))
        profileViewController.bind(profileViewModel)
        
        [
            homeViewController,
            feedViewController,
            myPlaceViewController,
            profileViewController
        ].forEach {
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
            $0.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.gray04], for: .normal)
            $0.tabBarItem.imageInsets = UIEdgeInsets(top: 3, left: 0, bottom: 0, right: 0)
        }

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
