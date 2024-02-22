//
//  NewSongCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import Foundation
import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NewSongCollectionViewCell"
    
    // MARK: - Views
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 10
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(backgroundImage)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        let imageSize: CGFloat = contentView.width

     
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            backgroundImage.widthAnchor.constraint(equalToConstant: imageSize),
            backgroundImage.heightAnchor.constraint(equalToConstant: imageSize)
        ])
        
        NSLayoutConstraint.activate([
            albumNameLabel.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 5),
            albumNameLabel.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor),
            albumNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor),
            artistNameLabel.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        albumNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: SongCellViewModel) {
        backgroundImage.sd_setImage(with: viewModel.backgroundImage)
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artist
    }
}
