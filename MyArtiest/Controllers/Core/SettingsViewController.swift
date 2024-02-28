//
//  ProfileViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit
import SDWebImage

class SettingsViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = SettingsViewModel()
    private var profileData: UserProfile?
    
    // MARK: - Views
    
    private var profilePictureImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 50
        imageView.layer.borderWidth = 4
        imageView.layer.borderColor = UIColor.customPrimary.cgColor
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    private var spotifyIdLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private var signOutButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.filled())
        button.configuration?.baseBackgroundColor = .customPrimary
        
        var buttonText = AttributedString("SIGN OUT")
        buttonText.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        button.configuration?.attributedTitle = buttonText
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchProfile()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        title = "Settings"
        view.backgroundColor = .customBackground
        
        let stackView = UIStackView()
        
        view.addSubview(stackView)
        
        stackView.addArrangedSubview(profilePictureImageView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(spotifyIdLabel)
        view.addSubview(signOutButton)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.axis = .vertical
        stackView.spacing = 10
        
        signOutButton.addTarget(self, action: #selector(signOutTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            profilePictureImageView.centerXAnchor.constraint(equalTo: stackView.centerXAnchor),
            profilePictureImageView.widthAnchor.constraint(equalToConstant: 100),
            profilePictureImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        NSLayoutConstraint.activate([
            signOutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signOutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 40)
        ])
    }
    
    private func updateUI() {
        
    }
    
    // MARK: - Functions
    
    private func fetchProfile() {
        viewModel.fetchProfile { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                switch result {
                case .success(let profile):
                    self.profileData = profile
                    self.configure()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func configure() {
        guard let profileData else { return }
        profilePictureImageView.sd_setImage(with: URL(string: profileData.images.first?.url ?? ""))
        nameLabel.text = profileData.display_name
        spotifyIdLabel.text = profileData.id
    }
    
    @objc func signOutTapped() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Sign Out", style: .destructive, handler: { _ in
            AuthManager.shared.signOut { [weak self] signedOut in
                DispatchQueue.main.async {
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
