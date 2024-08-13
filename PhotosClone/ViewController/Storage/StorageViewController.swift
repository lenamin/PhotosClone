//
//  StorageViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

class StorageViewController: UIViewController {
    
    // MARK: - Properties
    
    private let photoManager = PhotoManager.shared
    private var dateMode = DateMode.day(Date())
    
    private let allPhotosView = AllPhotosView()
    private let dayPhotosView = DayPhotosView()
    private let monthPhotosView = DayPhotosView()
    private let yearPhotosView = DayPhotosView()
    
    private let segmentedControl: UISegmentedControl = {
        let items = ["연", "월", "일", "모든사진"]
        let segmentedControl = UISegmentedControl(items: items)
        segmentedControl.selectedSegmentIndex = 3
        return segmentedControl
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        [dayPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
        allPhotosView.isHidden = false
        configureUI()
        configureConstraints()
        configureSegmentedControl()
        
        segmentedControl.selectedSegmentIndex = 3
        navigationItem.title = "모두보기"
        view.preservesSuperviewLayoutMargins = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        allPhotosView.removePinchGesture()
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
    }
    
    /// AutoLayout 설정
    func configureConstraints() {
        [allPhotosView, dayPhotosView,  monthPhotosView, yearPhotosView].forEach {
            $0.anchor(topAnchor: view.topAnchor, topPadding: 0, bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor)
            $0.setSize(width: UIScreen.main.bounds.width)
        }
        
        [allPhotosView,dayPhotosView, monthPhotosView, yearPhotosView, segmentedControl].forEach { $0.centerX(to: view) }
        
        segmentedControl.anchor(bottomAnchor: view.safeAreaLayoutGuide.bottomAnchor, bottomPadding: 12)
        segmentedControl.setSize(width: view.frame.width * 0.9, height: 40)
    }
    
    func configureSegmentedControl() {
        segmentedControl.backgroundColor = .systemGray6
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.white.cgColor], for:  .selected)
        segmentedControl.setTitleTextAttributes(
            [NSAttributedString.Key.foregroundColor: UIColor.systemGray.cgColor], for:  .normal)
        segmentedControl.selectedSegmentTintColor = .systemGray2
        segmentedControl.layer.cornerRadius = 48
        segmentedControl.layer.masksToBounds = true
        
        segmentedControl.addTarget(self, action: #selector(segmentedControlChanged), for: .valueChanged)
    }
    
    @objc private func segmentedControlChanged() {
        
        Task {
            let selectedIndex = segmentedControl.selectedSegmentIndex
            switch selectedIndex {
                case 3:
                    [dayPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                    allPhotosView.isHidden = false
                    navigationItem.title = "모두보기"
                    
                case 2:
                    dateMode = .day(Date())
                    [allPhotosView, monthPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                    dayPhotosView.isHidden = false
                    navigationItem.title = "일자별 보기"
                    await dayPhotosView.loadData(of: dateMode)
                    
                case 1:
                    dateMode = .month(Date())
                    monthPhotosView.isHidden = false
                    navigationItem.title = "월별 보기"
                    [dayPhotosView, allPhotosView, yearPhotosView].forEach { $0.isHidden = true }
                    await monthPhotosView.loadData(of: dateMode)
                    
                case 0:
                    dateMode = .year(Date())
                    yearPhotosView.isHidden = false
                    navigationItem.title = "연도별 보기"
                    [dayPhotosView, monthPhotosView, allPhotosView].forEach { $0.isHidden = true }
                    await yearPhotosView.loadData(of: dateMode)
                default:
                    break
            }
        }
    }
}
