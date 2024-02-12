//
//  AppDelegate.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        
        if AuthManager.shared.isSignedIn {
            AuthManager.shared.refreshTokenIfNeeded(completion: nil) // refreshes on launch
            if UserDefaults.standard.bool(forKey: "first_login") {
                window.rootViewController = SelectGenreViewController()
            } else {
                window.rootViewController = TabBarViewController()
            }
        } else {
            // need to have welcome/onboarding screen first. if local selected genre is there, take to main
            let navVC = UINavigationController(rootViewController: OnboardingViewController())
            navVC.navigationBar.prefersLargeTitles = true
            navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .automatic
            window.rootViewController = navVC
            
        }
        
        
        window.makeKeyAndVisible()
        self.window = window
    
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

