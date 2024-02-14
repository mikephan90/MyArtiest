//
//  FeaturedSongCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit
import SDWebImage

class RecommendedSongCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "RecommendedSongCollectionViewCell"
    
    // MARK: - Views
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.tintColor = .white
        
        return imageView
    }()
    
    private let overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .thin)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setup() {
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.customPrimary.cgColor
        
        contentView.largeContentTitle = "New Releases"
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(backgroundImage)
        contentView.addSubview(overlayView)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        addShadow()
        
        overlayView.frame = contentView.bounds
        
        NSLayoutConstraint.activate([
            backgroundImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            songNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            songNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            artistNameLabel.topAnchor.constraint(equalTo: songNameLabel.bottomAnchor, constant: 5),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        songNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: SongCellViewModel) {
        backgroundImage.sd_setImage(with: viewModel.backgroundImage)
        songNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artist
    }
}
