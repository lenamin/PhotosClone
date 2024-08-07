//
//  File.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

class PhotosTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
    }
    
}

private extension PhotosTabBarController {
    func configureTabBarItem() {
        let storageTab = UINavigationController(rootViewController: StorageViewController())
        let recommendTab = UINavigationController(rootViewController: RecommendViewController())
        let albumTab = UINavigationController(rootViewController: AlbumViewController())
        let searchTab = UINavigationController(rootViewController: SearchViewController())
    }
}
