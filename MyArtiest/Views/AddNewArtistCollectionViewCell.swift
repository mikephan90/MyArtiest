//
//  AddNewArtistCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/14/24.
//

import UIKit

protocol AddNewArtistCollectionViewCellDelegate: AnyObject {
    func didTapAddNewFavoriteArtist()
}

class AddNewArtistCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties
    
    static let identifier = "AddNewArtistCollectionViewCell"
    weak var delegate: AddNewArtistCollectionViewCellDelegate?
    
    // MARK: - Views
    
    private var artistButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .customForeground
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 10
        button.contentHorizontalAlignment = .left
        button.tintColor = .customPrimary
        button.setTitleColor(UIColor.customPrimary, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitle("Add New Artist", for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        
        return button
    }()
    
    private var buttonImage: UIImageView = {
        let config = UIImage.SymbolConfiguration(weight: .bold)
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "plus", withConfiguration: config)
        
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
        artistButton.addTarget(self, action: #selector(addArtistButtonPressed), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            artistButton.leadingAnchor.constraint(equalTo: leadingAnchor),
            artistButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            artistButton.topAnchor.constraint(equalTo: topAnchor),
            artistButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            buttonImage.trailingAnchor.constraint(equalTo: artistButton.trailingAnchor, constant: -15),
            buttonImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonImage.widthAnchor.constraint(equalToConstant: 16),
            buttonImage.heightAnchor.constraint(equalToConstant: 16),
        ])
    }
    
    // MARK: - Methods
    
    @objc func addArtistButtonPressed() {
        /** TODO: This will direct the user to the default search bar. Add listener to direct to the correct section/tab for artist. */
        delegate?.didTapAddNewFavoriteArtist()
    }

}
