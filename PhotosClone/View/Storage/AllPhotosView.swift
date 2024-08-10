//
//  AllPhotosView.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit
import Photos

class AllPhotosView: UIView, UIGestureRecognizerDelegate {
    
    private var asset: PHFetchResult<PHAsset>
    let imageManager = PHCachingImageManager()

    private var scale: CGFloat = 1.0
    private var numberOfColumns: Int = 3
    
    private var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var prefetchingIndexPathOperations = [IndexPath: PHImageRequestID]()

    override init(frame: CGRect) {
        let phFetchOptions = PHFetchOptions()
        phFetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        self.asset = PHAsset.fetchAssets(with: phFetchOptions)
        
        super.init(frame: frame)
        self.addAutoLayoutSubview(collectionView)
        configureCollectionView()
        configureLayout()
        setUpPinchGesture()
        updateFlowLayout(columns: numberOfColumns, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayout() {
        collectionView.stretchToEdges(useSafeArea: false)
        collectionView.setSize(width: self.frame.width)
        collectionView.isUserInteractionEnabled = true
    }

    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        
        collectionView.collectionViewLayout = layout
        collectionView.register(AllPhotosCollectionViewCell.self, forCellWithReuseIdentifier: AllPhotosCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
    }
}

// MARK: - CollectionView DataSource & Delegate & Prefetching

extension AllPhotosView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {

    // MARK: - Prefetching
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let cellSize = self.frame.width / CGFloat(numberOfColumns)
        let targetSize = CGSize(width: cellSize, height: cellSize)
        
        for indexPath in indexPaths {
            let asset = self.asset[indexPath.item]
            
            let requestID = imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
                
                guard let self = self else { return }
                if let storedRequestID = self.prefetchingIndexPathOperations[indexPath] {
                    if let cell = collectionView.cellForItem(at: indexPath) as? AllPhotosCollectionViewCell {
                        cell.imageView.image = image
                    }
                }
            }
            prefetchingIndexPathOperations[indexPath] = requestID
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let requestID = prefetchingIndexPathOperations.removeValue(forKey: indexPath) {
                imageManager.cancelImageRequest(requestID)
            }
        }
    }
    
    // MARK: - CollectionView Layout
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return asset.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AllPhotosCollectionViewCell.identifier, for: indexPath) as! AllPhotosCollectionViewCell
        
        let asset = self.asset[indexPath.row]
        cell.assetIdentifier = asset.localIdentifier
        
        let targetSize = CGSize(width: cell.bounds.width, height: cell.bounds.width)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { image, _ in
            if cell.assetIdentifier == asset.localIdentifier {
                cell.imageView.image = image
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.frame.width / CGFloat(numberOfColumns)
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    // MARK: - CollectionView Selection
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let asset = self.asset[indexPath.item]
        let fullScreenImageViewController = FullScreenImageViewController(asset: asset)
        
        if let viewController = findViewController() {
            viewController.navigationController?.pushViewController(fullScreenImageViewController, animated: true)
        }
    }
}

// MARK: - Pinch Gesture & Handle FlowLayout

extension AllPhotosView {
    
    private func setUpPinchGesture() {
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinchGesture(_:)))
        pinchGesture.delegate = self
        collectionView.addGestureRecognizer(pinchGesture)
    }
    
    @objc private func handlePinchGesture(_ gesture: UIPinchGestureRecognizer) {
        
        switch gesture.state {
            case .began, .changed:
                scale = max(0.1, min(3.0, 0.9 * gesture.scale))
                
                let newNumberOfColumns = calculateNumberOfColumns(for: scale)
                
                if numberOfColumns != newNumberOfColumns {
                    numberOfColumns = newNumberOfColumns
                    updateFlowLayout(columns: numberOfColumns, animated: true)
                }
            case .ended:
                UIView.animate(withDuration: 0.3) {
                    self.collectionView.transform = .identity
                }
                gesture.scale = 1.0
            default:
                break
        }
    }
    
    func updateFlowLayout(columns: Int, animated: Bool) {
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            
            let availableWidth = collectionView.bounds.width
            let itemWidth = availableWidth / CGFloat(columns)
            let newSize = CGSize(width: itemWidth, height: itemWidth)
            
            if animated {
                UIView.animate(withDuration: 0.3) {
                    layout.itemSize = newSize
                    layout.invalidateLayout()
                }
            } else {
                layout.itemSize = newSize
                layout.invalidateLayout()
            }
        }
    }
    
    /// - Returns: Number of columns
    private func calculateNumberOfColumns(for scale: CGFloat) -> Int {
        switch scale {
        case ..<0.3:
            return 30
        case 0.3..<0.6:
            return 15
        case 0.6..<0.8:
            return 5
        case 0.8..<1.1:
            return 3
        default:
            return 1
        }
    }
}
