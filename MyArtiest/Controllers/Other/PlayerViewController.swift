//
//  PlayerViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/14/24.
//

import UIKit
import SDWebImage

protocol PlayerViewControllerDelegate: AnyObject {
    func didTapPlayPause()
    func didTapNext()
    func didTapBack()
}

class PlayerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = PlayerViewModel()
    private let controlsView = PlayerControlsView()
    
    weak var dataSource: PlayerDataSource?
    weak var delegate: PlayerViewControllerDelegate?
    
    // MARK: - Views
    
    private var backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "endgame")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.zPosition = -2
        
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .customPrimary
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.zPosition = -1
        
        return view
    }()
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 100
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor.customPrimary.cgColor
        
        return imageView
    }()
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI

    
    private func setupUI() {
        backgroundImageView.frame = view.bounds
        overlayView.frame = view.bounds
        
        view.addSubview(backgroundImageView)
        view.addSubview(overlayView)
        view.addSubview(mainImageView)
        view.addSubview(controlsView)
        
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 200),
            mainImageView.heightAnchor.constraint(equalToConstant: 200),
            mainImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            
            controlsView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controlsView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            controlsView.heightAnchor.constraint(equalToConstant: 280),
            controlsView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: 20)
        ])
        
        setupGradientOverlay()
    }
    
    
    private func setupGradientOverlay() {
        // Create a new gradient layer
        let gradientLayer = CAGradientLayer()
        // Set the colors and locations for the gradient layer
        gradientLayer.colors = [UIColor.customBackground.cgColor, UIColor.clear.cgColor, UIColor.customBackground.cgColor]
        gradientLayer.locations = [0.0, 0.2, 0.8]
        
        // Set the start and end points for the gradient layer
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 1.0)
        
        // Set the frame to the layer
        gradientLayer.frame = view.frame
        
        // Add the gradient layer as a sublayer to the background view
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    // MARK: - Fetch Track Data
    
    private func configure() {
        backgroundImageView.sd_setImage(with: dataSource?.imageUrl, completed: nil)
        mainImageView.sd_setImage(with: dataSource?.imageUrl, completed: nil)
        controlsView.configure(with: SongCellViewModel(
            backgroundImage: nil,
            name: dataSource?.songName ?? "",
            artist: dataSource?.artistName ?? ""
        ))
    }
    
    func refreshUI() {
        configure()
    }
    
    // MARK: - Methods
    
}

extension PlayerViewController: PlayerViewControllerDelegate {
    func didTapPlayPause() {
        delegate?.didTapPlayPause()
    }
    
    func didTapNext() {
        delegate?.didTapNext()
    }
    
    func didTapBack() {
        delegate?.didTapBack()
    }
}
