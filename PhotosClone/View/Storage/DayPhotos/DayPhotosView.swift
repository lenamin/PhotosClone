//
//  ForYouPhotosView.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import UIKit
import Photos

class DayPhotosView: UIView {
    private(set) var assets: [PHAsset] = []
    private(set) var groupedAssets: [Date: [PHAsset]] = [:]
    var sortedDates: [Date] = []
    var sortedFormattedDates = [String]()
    private let imageManager = PHImageManager()
    
    
    
    private var prefetchingIndexPathOperations = [IndexPath: PHImageRequestID]()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
       
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(DayPhotosCollectionViewCell.self, forCellWithReuseIdentifier: DayPhotosCollectionViewCell.identifier)
        collectionView.register(CommonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommonHeaderView.identifier)

        collectionView.backgroundColor = .white
        collectionView.showsVerticalScrollIndicator = true
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override init(frame: CGRect) {

        super.init(frame: .zero)
        [collectionView].forEach { addAutoLayoutSubview($0) }
        configureCollectionView()
        configureLayout()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLayout() {
        collectionView.stretchToEdges(useSafeArea: false)
//        collectionView.setSize(width: self.frame.width)
        collectionView.isUserInteractionEnabled = true
    }
    
    private func configureCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        
    }
    /*
    func loadData() {
        
        let photoManager = PhotoManager.shared

        // 전체 날짜 범위를 가져옵니다
        guard let dateRange = photoManager.fetchDateRange() else {
            print("Unable to fetch date range.")
            return
        }

        // 전체 날짜 범위에 따라 자산을 그룹화합니다
        groupedAssets = photoManager.fetchGroupDateAssets(for: .range(dateRange.startDate, dateRange.endDate))
        
        // 날짜를 정렬하여 sortedDates 배열에 저장합니다
        sortedDates = groupedAssets.keys.sorted()
        print("== loadData() 안에서 sortedDates 개수: \(sortedDates.count)")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy년 M월 d일"
        sortedFormattedDates = sortedDates.map { dateFormatter.string(from: $0) }

        // UI 업데이트
        collectionView.reloadData()
    }
     */

    func updateAssets(_ groupedAssets: [Date: [PHAsset]]) {
        self.groupedAssets = groupedAssets
        collectionView.reloadData()
    }
    
    func loadData(of dateMode: DateMode) {
        let photoManager = PhotoManager.shared
        let range = photoManager.fetchDateRange()

        // 전체 날짜 범위를 가져옵니다
        guard let allDatesRange = photoManager.fetchDateRange() else { return }
        print("==loadData안에서 allDatesRange: \(allDatesRange)")
        
        // 전체 날짜 범위에 따라 자산을 그룹화합니다
        groupedAssets = photoManager.fetchRangeDateAssets(for: dateMode)
        
        // 날짜를 정렬하여 sortedDates 배열에 저장합니다
        sortedDates = groupedAssets.keys.sorted()
        print("== loadData(of: dateMode) 안에서 sortedDates 개수: \(sortedDates.count)")

        // 날짜 포맷 설정
        let dateFormatter = DateFormatter()
        switch dateMode {
        case .day:
            dateFormatter.dateFormat = "yyyy년 M월 d일"
        case .month:
            dateFormatter.dateFormat = "yyyy년 M월"
        case .year:
            dateFormatter.dateFormat = "yyyy년"
        }

        sortedFormattedDates = sortedDates.map { dateFormatter.string(from: $0) }

        // UI 업데이트
        collectionView.reloadData()
    }

}

// MARK: - Prefetching

extension DayPhotosView: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let cellSize = self.frame.width
        let targetSize = CGSize(width: cellSize, height: cellSize)
        /*
        for indexPath in indexPaths {
            let date = sortedDates[indexPath.section]
            let asset = groupedAssets[date] ?? []
            
            guard let assetValue = groupedAssets as [Date : [PHAsset]]?,
                  let value = assetValue[date] else { return }
            
            print("collectionView내의 prefetchItemsAT ==== value: \(value), indexPath.row: \(indexPath.row)")
            
            let requestID = imageManager.requestImage(for: value[indexPath.row], targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                
                guard let self = self else { return }
                if let _ = self.prefetchingIndexPathOperations[indexPath] {
                    if let cell = collectionView.cellForItem(at: indexPath) as? DayPhotosCollectionViewCell {
                        cell.imageView.image = image
                    }
                }
            }
            prefetchingIndexPathOperations[indexPath] = requestID
         */
        
        for indexPath in indexPaths {
            let date = sortedDates[indexPath.section] // 수정: section을 사용
            let assets = groupedAssets[date] ?? []
            
            if indexPath.item < assets.count {
                let asset = assets[indexPath.item]
                
                let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                    guard self != nil else { return }
                    if let cell = collectionView.cellForItem(at: indexPath) as? DayPhotosCollectionViewCell {
                        cell.imageView.image = image
                    }
                }
                prefetchingIndexPathOperations[indexPath] = requestID
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let requestID = prefetchingIndexPathOperations.removeValue(forKey: indexPath) {
                imageManager.cancelImageRequest(requestID)
            }
        }
    }
}

// MARK: - CollectionViewDataSource & Delegate

extension DayPhotosView: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DayPhotosCollectionViewCell.identifier, for: indexPath) as? DayPhotosCollectionViewCell  else { return  UICollectionViewCell() }
        /*
         let date = sortedDates[indexPath.section]
         print("data:")
         let asset = groupedAssets
         
         let value = asset[date] ?? [PHAsset]()
         let targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.width)
         
         print("collectionView내의 cellForItemAt ==== value: \(value), indexPath.row: \(indexPath.row)")
         
         let requestID = imageManager.requestImage(for: value[indexPath.row], targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
         
         guard let self = self else { return }
         if let _ = self.prefetchingIndexPathOperations[indexPath] {
         if let cell = collectionView.cellForItem(at: indexPath) as? DayPhotosCollectionViewCell {
         cell.imageView.image = image
         }
         }
         }
         */
        
        let date = sortedDates[indexPath.section]
        let assets = groupedAssets[date] ?? []
        
        if indexPath.item < assets.count {
            let asset = assets[indexPath.item]
            let targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.width)
            print("== cellForItem: \(asset)")
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
                print("imageManager를 활용해서 이미지를 삽입했다!")
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("numberOfSection에서 sortedDates.count: \(sortedDates.count)")
        return sortedDates.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let date = sortedDates[section]
        let counts = groupedAssets[date]?.count ?? 0
        print("numberOfItemsInSectionL \(counts)")
        return counts
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("collectionView에서 선택되었다!!")
        /*
        let date = Array(sortedDates[indexPath])
        
        guard let asset = groupedAssets[date] else { return }
        
        let storageViewController = StorageViewController(asset: asset[indexPath.item])
        

        if let viewController = findViewController() {
            viewController.navigationController?.pushViewController(fullScreenImageViewController, animated: true)
        }
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonHeaderView.identifier, for: indexPath) as? CommonHeaderView else { return CommonHeaderView() }
        
        let date = sortedDates[indexPath.section]
        print("viewForSupplementaryElementOfKind: \(date)")
        headerView.headerLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .none)
        
        return headerView
    }
}

extension DayPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 50)
    }
}
