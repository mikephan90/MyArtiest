//
//  PlayerViewController.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/14/24.
//

import UIKit
import SDWebImage

class PlayerViewController: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel = PlayerViewModel()
    private let controlsView = PlayerControlsView()
    private var selectedTrack: AudioTrack
    
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
    
    // MARK: -  Init
    
    init(selectedTrack: AudioTrack) {
        self.selectedTrack = selectedTrack
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
//        fetchTrack()
    }
    
    // MARK: - UI
    
    private func songData() {
        if let artistName = selectedTrack.artists.first?.name {
            controlsView.configure(with: SongCellViewModel(
                backgroundImage: nil,
                name: selectedTrack.name,
                artist: artistName)
            )
        }
    }
    
    private func setupUI() {
        tabBarController?.tabBar.isHidden = true
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
    
    private func fetchTrack() {
        viewModel.fetchTrack(track: selectedTrack) { [weak self] result in
            guard let self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let track):
                    // play the song with the fetched data
                    self.update()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Methods
    
    private func update() {
//        if let imageURL = selectedTrack.album?.images.first?.url {
//            backgroundImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
//            mainImageView.sd_setImage(with: URL(string: imageURL), completed: nil)
//        }
    }
    
    //    private func configureBarButtons() {
    //        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
    //        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))
    //    }
    //
    //    @objc private func didTapClose() {
    //        dismiss(animated: true, completion: nil)
    //    }
    //
    //    @objc private func didTapAction() {
    //
    //    }
}
