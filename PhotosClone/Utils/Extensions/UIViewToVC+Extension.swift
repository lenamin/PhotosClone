//
//  NavigateViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/9.
//

import UIKit

extension UIView {
    
    /// For navigating from UIView to UIViewController 
    func findViewController() -> UIViewController? {
        var view = self
        while let next = view.next {
            if let viewController = next as? UIViewController {
                return viewController
            }
            view = next as! UIView
        }
        return nil
    }
}
