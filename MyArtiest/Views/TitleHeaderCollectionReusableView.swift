//
//  TitleHeaderCollectionReusableView.swift
//  MyArtiest
//
//  Created by Mike Phan on 2/13/24.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    
    static let identifier = "TitleHeaderCollectionReusableView"
    
    private let labelText: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 18, weight: .bold)
        
        return label
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
    }
    
    func configure(with title: String) {
        labelText.text = title
    }
}
