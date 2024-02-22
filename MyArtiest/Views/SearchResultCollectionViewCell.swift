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
        label.numberOfLines = 2
        
        return label
    }()
    
    private let rightIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.right")
        imageView.tintColor = UIColor.customPrimary
        
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
        
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.customForeground.cgColor
        
        addSubview(iconImageView)
        addSubview(textLabel)
        addSubview(rightIconView)
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        rightIconView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            iconImageView.widthAnchor.constraint(equalToConstant: 60),
            iconImageView.heightAnchor.constraint(equalToConstant: 60),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 30),
            textLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            rightIconView.widthAnchor.constraint(equalToConstant: 10),
            rightIconView.heightAnchor.constraint(equalToConstant: 16),
            rightIconView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            rightIconView.centerYAnchor.constraint(equalTo: centerYAnchor)
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

