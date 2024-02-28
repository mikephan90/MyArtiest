//
//  GenreOptionCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/12/24.
//

import Foundation
import UIKit

class GenreOptionCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "GenreOptionCell"
    
    // MARK: - Views
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -  UI
    
    private func setupUI() {
        contentView.addSubview(labelText)
        contentView.backgroundColor = .customForeground
        contentView.layer.masksToBounds = true
        contentView.layer.cornerRadius = 10
        labelText.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            labelText.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelText.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            labelText.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            labelText.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - Methods
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? .customPrimary : .customForeground
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelText.text = nil
    }
    
    func configure(with type: String) {
        labelText.text = type
    }
}
