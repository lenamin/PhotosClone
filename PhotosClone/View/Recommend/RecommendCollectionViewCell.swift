//
//  RecommendCollectionViewCell.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/12.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendCollectionViewCell"
    
    /// album image view
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .checkmark
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 20)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    let numberOfPhotosLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.backgroundColor = .systemBackground
        [imageView, albumTitleLabel, numberOfPhotosLabel].forEach { contentView.addAutoLayoutSubview($0)
        }
        
        imageView.setSize(width: contentView.frame.width, height: contentView.frame.width)
        imageView.centerX(to: contentView)
        imageView.anchor(topAnchor: contentView.topAnchor)
        albumTitleLabel.anchor(topAnchor: imageView.bottomAnchor, topPadding: 4, bottomAnchor: numberOfPhotosLabel.topAnchor)
        
        [albumTitleLabel, numberOfPhotosLabel].forEach { $0.anchor(leadingAnchor: contentView.leadingAnchor) }
        numberOfPhotosLabel.anchor(bottomAnchor: contentView.bottomAnchor)
    }
}
