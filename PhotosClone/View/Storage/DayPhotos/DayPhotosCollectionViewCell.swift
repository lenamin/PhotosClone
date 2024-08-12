//
//  DayPhotosCollectionViewCell.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import UIKit

class DayPhotosCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DayPhotosCollectionViewCell"
    var assetIdentifier: String?
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        contentView.addAutoLayoutSubview(imageView)
        imageView.stretchToEdges(useSafeArea: false)
        imageView.preservesSuperviewLayoutMargins = false
    }
}
