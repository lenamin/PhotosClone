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
//        label.tag = 
        label.font = .boldSystemFont(ofSize: 44)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAutoLayoutSubview(headerLabel)
        headerLabel.stretchToEdges(useSafeArea: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        headerLabel.text = title
    }
}
