//
//  PlayerViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/14/24.
//

import UIKit

class PlayerViewController: UIViewController {
    
    // MARK: - Properties
    
    
    // MARK: - Views
    private let songNameLabel: UILabel = {
        let label = UILabel()
        
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        
        
        return label
    }()
    
    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "endgame")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.zPosition = -2
        
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = -1
        
        return view
    }()
    
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "endgame")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.customPrimary.cgColor
        
        return imageView
    }()
    
    
    // add player controls here in a separate this is just a header
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        backgroundImageView.frame = view.bounds
        
        view.addSubview(backgroundImageView)
        view.addSubview(mainImageView)
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40)
        ])
        
        setupGradientOverlay()
    }
    
    
    private func setupGradientOverlay() {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.customForeground.cgColor, UIColor.clear.cgColor, UIColor.customForeground.cgColor]
        gradientLayer.locations = [0.0, 0.2, 0.8]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    // MARK: - Methods
}
