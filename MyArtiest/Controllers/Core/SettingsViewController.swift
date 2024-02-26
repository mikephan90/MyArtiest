//
//  ProfileViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

import UIKit

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Views

    private var signOutButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.configuration?.baseBackgroundColor = .customPrimary
        
        var buttonText = AttributedString("SIGN OUT")
        buttonText.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.configuration?.attributedTitle = buttonText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()  
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .customBackground
        view.addSubview(signOutButton)
        
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        
        setupConstraints()
    }
    
    private func setupConstraints() {

        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func updateUI() {
        
    }

    // MARK: - Functions

    
    @objc func signOutTapped() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] signedOut in
                DispatchQueue.main.async {
                    #warning("TODO: FIX NAVIGATION FOR SIGN IN")
                    let navVC = UINavigationController(rootViewController: OnboardingViewController())
                    navVC.navigationBar.prefersLargeTitles = true
                    navVC.viewControllers.first?.navigationItem.largeTitleDisplayMode = .automatic
                    navVC.modalPresentationStyle = .fullScreen
                    self?.present(navVC, animated: true, completion: {
                        // Reset it back to the root controller
                        self?.navigationController?.popToRootViewController(animated: false)
                    })
                }
            }
        }))
        
        present(alert, animated: true)
    }
}
