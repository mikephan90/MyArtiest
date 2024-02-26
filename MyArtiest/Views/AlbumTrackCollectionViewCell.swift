//
//  AlbumTrackCollectionViewCell.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/20/24.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    static let identifier = "AlbumTrackCollectionViewCell"
    
    // MARK: - Views
    
    private let trackNumberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .thin)
        label.textAlignment = .center
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.customPrimary.cgColor
        
        return label
    }()
    
    private let songNameLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .darkGray
        
        return view
    }()
    
    private let moreIconButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = UIColor.customPrimary
        
        return button
    }()
    
    // MARK: -  Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        songNameLabel.text = nil
    }
    
    // MARK: - Layout
    
    private func setupView() {
        
        let horizontalStackView = UIStackView()
        horizontalStackView.axis = .horizontal
        
        addSubview(horizontalStackView)
        
        horizontalStackView.addArrangedSubview(trackNumberLabel)
        horizontalStackView.addArrangedSubview(songNameLabel)
//        horizontalStackView.addArrangedSubview(moreIconButton)
        horizontalStackView.spacing = 20
        
        trackNumberLabel.translatesAutoresizingMaskIntoConstraints = false
        songNameLabel.translatesAutoresizingMaskIntoConstraints = false
        moreIconButton.translatesAutoresizingMaskIntoConstraints = false
        horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    

        NSLayoutConstraint.activate([
            horizontalStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            horizontalStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            horizontalStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            trackNumberLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            trackNumberLabel.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    // MARK: - Methods
    
    func configure(with viewModel: AudioTrack, index: Int) {
        trackNumberLabel.text = String(index)
        songNameLabel.text = viewModel.name
    }
}
