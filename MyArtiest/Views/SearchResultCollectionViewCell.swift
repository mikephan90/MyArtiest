//
//  SearchResultCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/21/24.
//

import UIKit
import SDWebImage

class SearchResultCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "SearchResultCollectionViewCell"
    
    // MARK: - Views
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let textLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let rightIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        
        return imageView
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    
    private func setupUI() {
        addSubview(iconImageView)
        addSubview(textLabel)
        addSubview(rightIconView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        rightIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 30),
            textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200)
        ])
        
        NSLayoutConstraint.activate([
            rightIconView.widthAnchor.constraint(equalToConstant: 16),
            rightIconView.heightAnchor.constraint(equalToConstant: 16),
            rightIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        textLabel.text = nil
    }
    
    func configure(with viewModel: SearchResultViewModel) {
        iconImageView.sd_setImage(with: viewModel.imageUrl)
        textLabel.text = viewModel.label
    }
}

