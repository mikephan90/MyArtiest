//
//  PlayerControlsView.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/15/24.
//

import UIKit

protocol PlayerControlsViewDelegate: AnyObject {
    func viewDidTapPlayPause(_ playerControlView: PlayerControlsView)
    func viewDidTapNext(_ playerControlView: PlayerControlsView)
    func viewDidTapBack(_ playerControlView: PlayerControlsView)
}

class PlayerControlsView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PlayerControlsViewDelegate?
    
    // MARK: - Views
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        
        return label
    }()
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "backward.end",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular)
        )
        button.tintColor = .customPrimary
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "forward.end",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 30,
                weight: .regular
            )
        )
        
        button.tintColor = .customPrimary
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    private let playPauseButton: UIButton = {
        let button = UIButton()
        let image = UIImage(
            systemName: "play.circle.fill",
            withConfiguration: UIImage.SymbolConfiguration(
                pointSize: 70,
                weight: .regular)
        )
        button.tintColor = .customPrimary
        button.setImage(image, for: .normal)
        
        return button
    }()
    
    // Add menu button to Go to Artist/Album pages and Save artist button
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI
    
    private func setupUI() {
        backgroundColor = .clear
        
        addSubview(songNameLabel)
        addSubview(artistNameLabel)
        
        clipsToBounds = true
    }
    
    // MARK: - Lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let controlsStackview = UIStackView()
        
        controlsStackview.axis = .horizontal
        controlsStackview.alignment = .center
        
        controlsStackview.addArrangedSubview(backButton)
        controlsStackview.addArrangedSubview(playPauseButton)
        controlsStackview.addArrangedSubview(nextButton)
        
        addSubview(controlsStackview)
        
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        artistNameLabel.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        
        controlsStackview.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            songNameLabel.topAnchor.constraint(equalTo: topAnchor),
            songNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            songNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 10),
            artistNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            artistNameLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            controlsStackview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -70),
            controlsStackview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            controlsStackview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            controlsStackview.heightAnchor.constraint(equalToConstant: 90),
            
            backButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor),
            playPauseButton.centerXAnchor.constraint(equalTo: controlsStackview.centerXAnchor),
            nextButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor),
        ])
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: SongCellViewModel) {
        songNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artist
    }
}
