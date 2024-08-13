//
//  NavigateViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/9.
//

import UIKit

extension UIView {
    
    /// UIView에서 UIViewController로의 pushViewController할 VC를 찾는 메서드
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
