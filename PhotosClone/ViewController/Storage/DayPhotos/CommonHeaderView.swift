//
//  DayPhotosHeaderView.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import UIKit

class CommonHeaderView: UICollectionReusableView {
    static let identifier = "HeaderView"
    
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 30)
        label.textColor = .black
        label.textAlignment = .left
        label.adjustsFontForContentSizeCategory = true
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAutoLayoutSubview(headerLabel)
        headerLabel.stretchToEdges(commonPadding: 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        headerLabel.text = title
    }
}
