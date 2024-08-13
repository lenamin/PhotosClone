//
//  RecommendCollectionViewCell.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/12.
//

import UIKit

class RecommendCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "RecommendCollectionViewCell"
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let albumTitleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let numberOfPhotosLabel: UILabel = {
       let label = UILabel()
        label.textColor = .gray
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 14)
        label.adjustsFontSizeToFitWidth = true
        label.adjustsFontForContentSizeCategory = true
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
        [imageView, albumTitleLabel, numberOfPhotosLabel].forEach { 
            contentView.addAutoLayoutSubview($0)
        }
    }
    
    func configure(for section: Int) {
        let width = contentView.frame.width - 12
        
        imageView.setSize(width: width, height: width)
        imageView.centerX(to: contentView)
        imageView.anchor(topAnchor: contentView.topAnchor)
        
        albumTitleLabel.anchor(topAnchor: imageView.bottomAnchor, 
                               topPadding: 4,
                               bottomAnchor: numberOfPhotosLabel.topAnchor)
        numberOfPhotosLabel.anchor(bottomAnchor: contentView.bottomAnchor, 
                                   bottomPadding: 0)
        
        [albumTitleLabel, numberOfPhotosLabel].forEach {
            $0.anchor(leadingAnchor: contentView.leadingAnchor, leadingPadding: 12)
            $0.setSize(height: 16)
        }
        numberOfPhotosLabel.anchor(leadingAnchor: albumTitleLabel.leadingAnchor)
    }
}
