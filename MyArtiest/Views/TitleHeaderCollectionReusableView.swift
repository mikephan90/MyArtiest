//
//  TitleHeaderCollectionReusableView.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import UIKit

protocol TitleHeaderCollectionReusableViewDelegate: AnyObject {
    func didTapAddNewFavoriteArtist()
}

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "TitleHeaderCollectionReusableView"
    private var addArtist: Bool!
    weak var delegate: TitleHeaderCollectionReusableViewDelegate?
    
    // MARK: - Views
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
    }()
    
    private let addArtistButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus", withConfiguration: config), for: .normal)
        button.tintColor = .customPrimary
            
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(labelText)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - UI
    
    override func layoutSubviews() {
        super.layoutSubviews()
        labelText.frame = CGRect(x: 14, y: 0, width: width - 30, height: height)
        
        addArtistButton.addTarget(self, action: #selector(addNewArtistButtonPressed), for: .touchUpInside)
    
        if addArtist {
            addSubview(addArtistButton)
            addArtistButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                addArtistButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -22),
                addArtistButton.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        }
    }
    
    // MARK: - Methods
    
    @objc func addNewArtistButtonPressed() {
        delegate?.didTapAddNewFavoriteArtist()
    }
    
    func configure(with title: String, _ addArtistSection: Bool = false) {
        labelText.text = title

        self.addArtist = addArtistSection
    }
}
