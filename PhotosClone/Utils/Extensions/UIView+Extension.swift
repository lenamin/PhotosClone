//
//  UIView+Extension.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

extension UIView {
    
    // MARK: - Auto Layout Helpers
    
    func setupForAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    @discardableResult
    func pinToSuperviewEdges(_ edges: UIEdgeInsets = .zero, useSafeArea: Bool = false) -> [NSLayoutConstraint] {
        setupForAutoLayout()
        
        guard let superview = superview else {
            fatalError("Superview must not be nil")
        }
        
        let safeArea = useSafeArea ? superview.safeAreaLayoutGuide : superview.layoutMarginsGuide
        
        let constraints = [
            self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: edges.top),
            self.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: edges.left),
            self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -edges.bottom),
            self.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -edges.right)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func setWidth(_ width: CGFloat) -> NSLayoutConstraint {
        setupForAutoLayout()
        
        let constraint = self.widthAnchor.constraint(equalToConstant: width)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    @discardableResult
    func setHeight(_ height: CGFloat) -> NSLayoutConstraint {
        setupForAutoLayout()
        
        let constraint = self.heightAnchor.constraint(equalToConstant: height)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    @discardableResult
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
        setupForAutoLayout()
        
        var constraints: [NSLayoutConstraint] = []
        
        if let width = width {
            constraints.append(self.widthAnchor.constraint(equalToConstant: width))
        }
        
        if let height = height {
            constraints.append(self.heightAnchor.constraint(equalToConstant: height))
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func centerInSuperview() -> [NSLayoutConstraint] {
        setupForAutoLayout()
        
        guard let superview = superview else {
            fatalError("Superview must not be nil")
        }
        
        let constraints = [
            self.centerXAnchor.constraint(equalTo: superview.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: superview.centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func alignCenterHorizontally(to view: UIView) -> NSLayoutConstraint {
        setupForAutoLayout()
        
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    @discardableResult
    func alignCenterVertically(to view: UIView) -> NSLayoutConstraint {
        setupForAutoLayout()
        
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
}
