//
//  TabBarViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = ProfileViewController()
        let vc2 = HomeViewController()
        let vc3 = RadioViewController()
        
        vc1.title = "Profile"
        vc2.title = "Home"
        vc3.title = "Radio"
        
        vc1.navigationItem.largeTitleDisplayMode = .always
        vc2.navigationItem.largeTitleDisplayMode = .always
        vc3.navigationItem.largeTitleDisplayMode = .always
        
        let nav1 = UINavigationController(rootViewController: vc1)
        let nav2 = UINavigationController(rootViewController: vc2)
        let nav3 = UINavigationController(rootViewController: vc3)
        
        nav1.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.crop.circle.fill"), tag: 1)
        nav2.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        nav3.tabBarItem = UITabBarItem(title: "Radio", image: UIImage(systemName: "radio"), tag: 1)
        
        nav1.navigationBar.prefersLargeTitles = true
        nav2.navigationBar.prefersLargeTitles = true
        nav3.navigationBar.prefersLargeTitles = true
        
        setViewControllers([nav1, nav2, nav3], animated: false)
    }
}
