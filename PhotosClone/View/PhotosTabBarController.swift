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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureTabBarItem()
    }
}

private extension PhotosTabBarController {
    func configureTabBarItem() {
        let storageTab = UINavigationController(rootViewController: StorageViewController())
        let storageTabItem = UITabBarItem(title: "보관함", image: SFSymbol.storage.image, tag: 0)
        storageTab.tabBarItem = storageTabItem
        
        let recommendTab = UINavigationController(rootViewController: RecommendViewController())
        let recommendTabItem = UITabBarItem(title: "For You", image: SFSymbol.recommend.image, tag: 0)
        recommendTab.tabBarItem = recommendTabItem
        
        let albumTab = UINavigationController(rootViewController: AlbumViewController())
        let albumTabItem = UITabBarItem(title: "앨범", image: SFSymbol.album.image, tag: 0)
        albumTab.tabBarItem = albumTabItem
        
        let searchTab = UINavigationController(rootViewController: SearchViewController())
        let searchTabItem = UITabBarItem(title: "검색", image: SFSymbol.search.image, tag: 0)
        searchTab.tabBarItem = searchTabItem
        
        self.viewControllers = [storageTab, recommendTab, albumTab, searchTab]
    }
}
