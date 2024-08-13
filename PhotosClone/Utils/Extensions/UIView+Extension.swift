//
//  UIView+Extension.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

// MARK: - AutoLayout 설정

extension UIView {
    
    func addAutoLayoutSubview(_ subview: UIView) {
        subview.setupForAutoLayout()
        self.addSubview(subview)
    }
    
    func setupForAutoLayout() {
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    /// 각 edge의 padding을 정함
    @discardableResult
    func anchor(
        topAnchor: NSLayoutYAxisAnchor? = nil, topPadding : CGFloat = 0,
        leadingAnchor: NSLayoutXAxisAnchor? = nil, leadingPadding : CGFloat = 0,
        bottomAnchor: NSLayoutYAxisAnchor? = nil, bottomPadding : CGFloat = 0,
        trailingAnchor: NSLayoutXAxisAnchor? = nil, trailingPadding : CGFloat = 0,
        useSafeAreaTop: Bool = false,
        useSafeAreaBottom: Bool = false
    ) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("Superview should not be nil")
        }
        var constraints: [NSLayoutConstraint] = []
        
        if let top = topAnchor {
            let topAnchor = useSafeAreaTop ? superview.safeAreaLayoutGuide.topAnchor : top
            constraints.append(self.topAnchor.constraint(equalTo: topAnchor, constant: topPadding))
        }
        
        if let leading = leadingAnchor {
            constraints.append(self.leadingAnchor.constraint(equalTo: leading, constant: leadingPadding))
        }
        
        if let bottom = bottomAnchor {
            let bottomAnchor = useSafeAreaBottom ? superview.safeAreaLayoutGuide.bottomAnchor : bottom
            constraints.append(self.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -bottomPadding))
        }
        
        if let trailing = trailingAnchor {
            constraints.append(self.trailingAnchor.constraint(equalTo: trailing, constant: trailingPadding))
        }
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }

    /// superview 까지 늘리는 메서드
    /// - Parameter commonPadding: 모든 패딩값이 동일 할 때 사용
    @discardableResult
    func stretchToEdges(commonPadding: CGFloat = -8,
                        topPadding: CGFloat? = nil,
                        leadingPadding: CGFloat? = nil,
                        bottomPadding: CGFloat? = nil,
                        trailingPadding: CGFloat? = nil,
                        useSafeArea: Bool = false) -> [NSLayoutConstraint] {
        guard let superview = superview else {
            fatalError("\(self.debugDescription)의 Superview must not be nil")
        }
        
        let safeArea = useSafeArea ? superview.safeAreaLayoutGuide : superview.layoutMarginsGuide
        
        let top = topPadding ?? commonPadding
        let leading = leadingPadding ?? commonPadding
        let bottom = bottomPadding ?? commonPadding
        let trailing = trailingPadding ?? commonPadding
        
        let constraints = [
            self.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: top),
            self.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: leading),
            self.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor, constant: -bottom),
            self.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -trailing)
        ]
        
        NSLayoutConstraint.activate(constraints)
        return constraints
    }
    
    @discardableResult
    func setSize(width: CGFloat? = nil, height: CGFloat? = nil) -> [NSLayoutConstraint] {
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
    func centerSuperview() -> [NSLayoutConstraint] {
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
    func centerX(to view: UIView) -> NSLayoutConstraint {
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
    
    @discardableResult
    func centerY(to view: UIView) -> NSLayoutConstraint {
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        NSLayoutConstraint.activate([constraint])
        return constraint
    }
}

// MARK: - UIPinGesture 관련

extension UIView {
    func removePinchGesture() {
        gestureRecognizers?.forEach { gesture in
            if let pinchGesture = gesture as? UIPinchGestureRecognizer {
                removeGestureRecognizer(pinchGesture)
            }
        }
    }
}
