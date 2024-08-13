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
    var dateMode: DateMode?
    private let imageManager = PHImageManager()
    
    private var prefetchingIndexPathOperations = [IndexPath: PHImageRequestID]()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 24
        layout.minimumLineSpacing = 12
       
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
        collectionView.isUserInteractionEnabled = true
    }
    
    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }

    func updateAssets(_ groupedAssets: [Date: [PHAsset]]) {
        self.groupedAssets = groupedAssets
        collectionView.reloadData()
    }
    
    func loadData(of dateMode: DateMode) async {
        let photoManager = PhotoManager.shared
        
        do {
            self.dateMode = dateMode
            // 그룹화
            groupedAssets = photoManager.fetchRangeDateAssets(for: dateMode)
        
            // 날짜를 정렬하여 sortedDates 배열에 저장
            sortedDates = groupedAssets.keys.sorted().reversed()
            
            let dateFormatter = DateFormatter.formatter(for: dateMode)
            sortedFormattedDates = sortedDates.map {
                dateFormatter.string(from: $0)
            }
            try await Task.sleep (nanoseconds: 1 * 1_000_000_000)
            collectionView.reloadData()
        } catch {
            print("사진 데이터를 가져오는데에 요루 발생 (loaddata(of:) : \(error.localizedDescription)")
        }
    }
}

// MARK: - CollectionView Prefetching

extension DayPhotosView: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let cellSize = self.frame.width
        let targetSize = CGSize(width: cellSize, height: cellSize)
        
        for indexPath in indexPaths {
            let date = sortedDates[indexPath.section]
            let assets = groupedAssets[date] ?? []
            
            if indexPath.item < assets.count {
                let asset = assets[indexPath.item]
                
                let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                    
                    guard let self = self else { return }
                    
                    if let cell = self.collectionView.cellForItem(at: indexPath) as? DayPhotosCollectionViewCell {
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
        
        let date = sortedDates[indexPath.section]
        let assets = groupedAssets[date] ?? []
        
        if indexPath.item < assets.count {
            let asset = assets[indexPath.item]
            let targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.width)
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    if let currentCell = self.collectionView.cellForItem(at: indexPath) as? DayPhotosCollectionViewCell {
                        currentCell.imageView.image = image
                    }
                }
            }
        }
        
        cell.layer.shadowOffset = CGSize(width: 0.3, height: 0.3)
        cell.layer.cornerRadius = 8
        cell.layer.shadowOpacity = 0.6
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sortedDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let date = sortedDates[section]
        let counts = groupedAssets[date]?.count ?? 0
        
        return counts
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let date = sortedDates[indexPath.section]
        let assets = groupedAssets[date] ?? []
        let asset = assets[indexPath.item]
        
        let fullScreenImageViewController = FullScreenImageViewController(asset: asset)

        if let viewController = findViewController() {
            viewController.navigationController?.pushViewController(fullScreenImageViewController, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CommonHeaderView.identifier, for: indexPath) as? CommonHeaderView else { return CommonHeaderView() }
        
        let date = sortedDates[indexPath.section]
        let formatter = DateFormatter.formatter(for: dateMode ?? .day(Date()))
        headerView.headerLabel.text = formatter.string(from: date)
        return headerView
    }
}

// MARK: - FlowLayout 

extension DayPhotosView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - 24
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = collectionView.bounds.width - 24
        return CGSize(width: width, height: 60)
    }
}
