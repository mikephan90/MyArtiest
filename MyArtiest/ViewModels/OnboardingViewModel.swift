//
//  OnboardingViewModel.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation
import UIKit

class OnboardingViewModel {
    
    // MARK: - Properties
    
    private let authManager = AuthManager.shared
    
    var signInCompletion: ((Bool) -> Void)?
    
    // MARK: - Methods
    
    func signIn(navigationController: UINavigationController?) {
        let authViewController = AuthViewController()
        
        authViewController.completionHandler = { [weak self] success in
            self?.signInCompletion?(success)
            navigationController?.popToRootViewController(animated: true)
        }
        navigationController?.pushViewController(authViewController, animated: true)
        
        func exchangeCodeForToken(code: String) {
            authManager.exchangeCodeForToken(code: code) { [weak self] success in
                self?.signInCompletion?(success)
            }
        }
    }
}

