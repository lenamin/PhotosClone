//
//  StorageViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

class StorageViewController: UIViewController {
    
    private let photoManager = PhotoManager.shared
    
    private var dateMode = DateMode.day(Date())
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["연", "월", "일", "모든사진"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 3
        return segmentedControl
    }()
    
    private let allPhotosView = AllPhotosView()
    private let dayPhotosView = DayPhotosView()
    private let monthPhotosView = DayPhotosView()
    private let yearPhotosView = DayPhotosView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [dayPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
        allPhotosView.isHidden = false
        configureUI()
        configureConstraints()
        configureSegmentedControl()
        segmentedControlChanged()

        segmentedControl.selectedSegmentIndex = 3
        view.preservesSuperviewLayoutMargins = false
    }
    
}

private extension StorageViewController {
    
    /// UI 설정
    func configureUI() {
        view.backgroundColor = .white
        allPhotosView.backgroundColor = .white
        view.addAutoLayoutSubview(allPhotosView)
        [dayPhotosView, monthPhotosView, yearPhotosView, segmentedControl].forEach { view.addAutoLayoutSubview($0)
            $0.backgroundColor = .white
        }
        navigationController?.navigationBar.backgroundColor = .clear
    }
    
    /// AutoLayout 설정
    func configureConstraints() {
        [allPhotosView, dayPhotosView,  monthPhotosView, yearPhotosView].forEach {
            $0.anchor(topAnchor: view.topAnchor, topPadding: 0, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
            $0.setSize(width: UIScreen.main.bounds.width)
        }
        
        [allPhotosView,dayPhotosView, monthPhotosView, yearPhotosView, segmentedControl].forEach { $0.centerX(to: view) }
        
        segmentedControl.anchor(bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomPadding: 12)
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
            case 3:
                [dayPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                allPhotosView.isHidden = false
                print("selectedIndex가 3이고, allPhotosView를 띄운다")
                
            case 2:
                dateMode = .day(Date())
                [allPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                dayPhotosView.isHidden = false
                dayPhotosView.loadData(of: dateMode)
                print("selectedIndex가 2이고, dayPhotosView를 띄운다")
                
            case 1:
                dateMode = .month(Date())
                monthPhotosView.isHidden = false
                [dayPhotosView, allPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                print("selectedIndex가 1이고, monthPhotosView를 띄운다")
                monthPhotosView.loadData(of: dateMode)
            case 0:
                dateMode = .year(Date())
                yearPhotosView.isHidden = false
                [dayPhotosView, monthPhotosView, allPhotosView].forEach { $0.isHidden = true }
                print("selectedIndex가 0이고, yearPhotosView를 띄운다")
                yearPhotosView.loadData(of: dateMode)
            default:
                break
        }
    }
    /*
    private func updateAssets(for dateRange: DateGroupRange) {
        guard photoManager.fetchDateRange() != nil else {
            return print("StorageVC의 updateAssets== 날짜범위 가져오는데 실패함")}
        
        let groupedAssets = photoManager.fetchGroupDateAssets(for: dateRange)
        
        switch DateMode.self {
            case .day:
                dayPhotosView.loadData(of: .day(Date()))
//                dayPhotosView.updateAssets(groupedAssets)
            case .month:
//                monthPhotosView.updateAssets(groupedAssets)
                monthPhotosView.loadData(of: .month(Date()))
            case .year:
//                yearPhotosView.updateAssets(groupedAssets)
                yearPhotosView.loadData(of: .year(Date()))
        }
    }*/
}
