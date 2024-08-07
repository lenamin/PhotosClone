//
//  Images.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

enum SFSymbol: String {
    case storage = "photo.fill.on.rectangle.fill"
    case recommend = "heart.text.square.fill"
    case album = "rectangle.stack.fill"
    case search = "magnifyingglass"

    var image: UIImage? {
        return UIImage(systemName: self.rawValue)
    }
}
