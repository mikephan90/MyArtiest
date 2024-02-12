//
//  FeaturedSongCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import UIKit

class FeaturedSongCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "FeaturedSongCollectionViewCell"
    
    // MARK: - Views
    
    private let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        
        return imageView
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.numberOfLines = 0
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.largeContentTitle = "Featured Song"
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(backgroundImage)
        contentView.addSubview(songNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundImage.image = nil
        songNameLabel.text = nil
        artistNameLabel.text = nil
    }
    
    func configure(with viewModel: SongCellViewModel) {
//        backgroundImage.sd_setImage
        songNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artist
    }
}
