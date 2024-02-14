//
//  FavoriteArtistCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/14/24.
//

import UIKit

class FavoriteArtistCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FavoriteArtistCollectionViewCell"
    
    // MARK: - Views
    
    private var artistButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customForeground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
        button.tintColor = .customPrimary
        button.setTitleColor(UIColor.customPrimary, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        return button
    }()
    
    private var buttonImage: UIImageView = {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right", withConfiguration: config)
        
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        buttonImage.image = nil
    }
    
    // MARK: - Layout
    
    private func setupView() {
        addSubview(artistButton)
        artistButton.addSubview(buttonImage)
        
        artistButton.translatesAutoresizingMaskIntoConstraints = false
        buttonImage.translatesAutoresizingMaskIntoConstraints = false
        
        artistButton.addTarget(self, action: #selector(favoriteArtistPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            artistButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            artistButton.topAnchor.constraint(equalTo: topAnchor),
            artistButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            buttonImage.trailingAnchor.constraint(equalTo: artistButton.trailingAnchor, constant: -15),
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: 10),
            buttonImage.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    // MARK: - Methods
    
    @objc func favoriteArtistPressed() {
        print("pressed")
        
        artistButton.backgroundColor = .customBackground
        artistButton.layer.borderWidth = 1
        artistButton.layer.borderColor = UIColor.customPrimary.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.artistButton.backgroundColor = .customForeground
            self.artistButton.layer.borderWidth = 0
            self.artistButton.layer.borderColor = nil
        }
               
        
        // do query on this artist return tracks and albums
    }
    
    
    func configure(with name: String) {
        artistButton.setTitle(name, for: .normal)
    }
}
