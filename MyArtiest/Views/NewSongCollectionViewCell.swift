//
//  NewSongCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import Foundation
import UIKit

class NewSongCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "NewSongCollectionViewCell"
    
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
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .light)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
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
        songNameLabel.text = "song name"
        artistNameLabel.text = "artist name"
    }
}
