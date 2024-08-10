//
//  StorageViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

class StorageViewController: UIViewController {
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["연", "월", "일", "모든사진"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 3
        return segmentedControl
    }()
    
    private let allPhotosView = AllPhotosView()
    
    private let containerView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureConstraints()
        configureSegmentedControl()
        view.preservesSuperviewLayoutMargins = false
    }
}

private extension StorageViewController {
    
    /// UI 설정
    func configureUI() {
        view.backgroundColor = .white
        allPhotosView.backgroundColor = .white
        [allPhotosView, segmentedControl].forEach { view.addAutoLayoutSubview($0) }
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    /// AutoLayout 설정
    func configureConstraints() {
        allPhotosView.anchor(topAnchor: view.topAnchor, topPadding: 0, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
        
        segmentedControl.anchor(bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomPadding: 12)
        
        [allPhotosView,segmentedControl].forEach { $0.centerX(to: view) }
        
        allPhotosView.setSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - segmentedControl.frame.height)
        segmentedControl.setSize(width: view.frame.width * 0.9,height: 40)
    }
    
    func configureSegmentedControl() {
        segmentedControl.backgroundColor = .systemGray6
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.white.cgColor], for:  .selected)
        segmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.systemGray.cgColor], for:  .normal)
        segmentedControl.selectedSegmentTintColor = .systemGray2
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.cornerRadius = 48
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)

        // TODO: - segmentedcontrol UI 프로토타입이랑 유사하도록 수정할 것
        // 1) cornerRadius 적용되게
        // 2) 글자 색깔 및 selected 됐을 때 배경색상 변경 v
        // 3) divider 없애기
    }
    
    @objc private func segmentedControlChanged() {
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        switch selectedIndex {
            case 0:
                allPhotosView.isHidden = false
            case 1:
                allPhotosView.isHidden = false
            case 2:
                allPhotosView.isHidden = false
            case 3:
                allPhotosView.isHidden = false
            default:
                break
            
        }
    }
}
