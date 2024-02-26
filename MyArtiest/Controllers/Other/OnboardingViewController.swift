//
//  OnboardingViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = OnboardingViewModel()
    
    // MARK: - Views
    
    private let signInButton: UIButton = {
        let button = UIButton(configuration: UIButton.Configuration.borderedProminent())
        button.configuration?.baseBackgroundColor = .customPrimary
        var buttonText = AttributedString.init("SIGN IN")
        buttonText.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        button.configuration?.attributedTitle = buttonText
        
        return button
    }()
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "albums")
        imageView.layer.zPosition = -1
        imageView.layer.opacity = 0.3
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Listen to millions of\nsongs using your \nSpotify account!"
        label.font = .systemFont(ofSize: 32, weight: .bold)
        
        return label
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
        setupGradientOverlay()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        label.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            signInButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.heightAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    private func setupViews() {
        title = "MyArtiest"
        view.backgroundColor = .customBackground
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        view.addSubview(label)
        view.addSubview(signInButton)
        view.addSubview(backgroundImage)
    }
    
    private func setupViewModel() {
        viewModel.signInCompletion = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
    }
    
    private func setupGradientOverlay() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.customForeground.cgColor,
            UIColor.clear.cgColor,
            UIColor.customBackground.cgColor
        ]
        gradientLayer.locations = [0.0, 0.2, 0.8]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.frame = view.frame

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Methods
    
    @objc func didTapSignIn() {
        viewModel.signIn(navigationController: navigationController)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Oops", message: "Something went wrong signing in", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert, animated: true)
            return
        }
        
        let mainAppTabVarVC = TabBarViewController()
        mainAppTabVarVC.modalPresentationStyle = .fullScreen
        present(mainAppTabVarVC, animated: true)
    }
}
