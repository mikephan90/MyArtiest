//
//  ExpandFooterCollectionReusableView.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/23/24.
//

import UIKit

protocol ExpandFooterCollectionReusableViewDelegate: AnyObject {
    func didTapExpandTrackList()
}

class ExpandFooterCollectionReusableView: UICollectionReusableView {
    // MARK: - Properties
    
    static let identifier = "ExpandFooterCollectionReusableView"
    weak var delegate: ExpandFooterCollectionReusableViewDelegate?
    
    // MARK: - Views
    
    private let arrowButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle("VIEW MORE", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 12, weight: .thin)
        button.titleLabel?.tintColor = .customPrimary
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(arrowButton)
        
        NSLayoutConstraint.activate([
            arrowButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            arrowButton.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        arrowButton.addTarget(self, action: #selector(arrowButtonTapped), for: .touchUpInside)
        
        layer.backgroundColor = UIColor.customForeground.cgColor
        layer.borderWidth = 1
        layer.borderColor = UIColor.customPrimary.cgColor
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - Methods
    
    @objc private func arrowButtonTapped() {
        delegate?.didTapExpandTrackList()
    }
}
