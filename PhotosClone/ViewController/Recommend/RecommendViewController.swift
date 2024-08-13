//
//  RecommendViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit
import CoreLocation
import Photos

class RecommendViewController: UIViewController {
    
    // MARK: - Properties
    
    private var albumData: [[PHAsset]] = []
    private var subtypeData: [Int: [PHAsset]] = [:]
    private let photoManager = PhotoManager.shared
    
    private let myAlbumCollecionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        collectionView.register(CommonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommonHeaderView.identifier)
        
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        [myAlbumCollecionView].forEach { view.addAutoLayoutSubview($0) }
        myAlbumCollecionView.stretchToEdges(useSafeArea: true)
        configureCollectionView()
        configureNavigation()
        
        Task {
            await loadData()
            myAlbumCollecionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigation()
    }
    
    private func configureNavigation() {
        navigationItem.title = "앨범"
        navigationItem.largeTitleDisplayMode = .automatic
    }
    
    // MARK: - Compositional Layout
    
    private func createPerSectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            // Header 레이아웃
            let headerSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .estimated(44))
            
            let header = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            // Item 레이아웃
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                  heightDimension: .fractionalWidth(0.5))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
          
            // 두 개의 아이템을 수평으로 배치하기 위한 nestedGroup 설정
            let nestedGroupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalWidth(0.5))
            
            let nestedGroup = NSCollectionLayoutGroup.horizontal(
                layoutSize: nestedGroupSize,
                subitem: item,
                count: 2
            )
            
            nestedGroup.interItemSpacing = .fixed(2)
            
            let verticalGroupSize = NSCollectionLayoutSize(
                widthDimension: .estimated(layoutEnvironment.container.contentSize.width - 24),
                heightDimension: .estimated(layoutEnvironment.container.contentSize.width - 24))
            
            
            let verticalGroup = NSCollectionLayoutGroup.vertical(
                layoutSize: verticalGroupSize,
                subitems: [nestedGroup, nestedGroup]
            )
            
            let section = NSCollectionLayoutSection(group: verticalGroup)
            section.orthogonalScrollingBehavior = .continuous
            section.boundarySupplementaryItems = [header]
        
            section.interGroupSpacing = 0
            verticalGroup.interItemSpacing = .fixed(0)
            
            return section
        }
        return layout
    }
    
    private func configureCollectionView() {
        myAlbumCollecionView.dataSource = self
        myAlbumCollecionView.delegate = self
        
        let layout = createPerSectionLayout()
        myAlbumCollecionView.collectionViewLayout = layout
    }
}

// MARK: - ColectionView Delegate & DataSource

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumData[section].count
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return albumData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return UICollectionViewCell() }
        
        cell.configure(for: indexPath.section)
        
        let assets = albumData[indexPath.section]
        let asset = assets[indexPath.item]
        
        // 지역찾기
        let latitude = asset.location?.coordinate.latitude ?? 0.0
        let longitude = asset.location?.coordinate.longitude ?? 0.0
        
        Task {
            let address = await LocationManager.shared.reverseGeocode(latitude: latitude, longitude: longitude)
            cell.albumTitleLabel.text = address
        }
        
        // 날짜
        let assetCreationDate = asset.creationDate
        cell.numberOfPhotosLabel.text = DateFormatter().formattedDateInKorean(from: assetCreationDate)
        
        Task {
            let imageWidth = cell.imageView.bounds.width
            let targetSize = CGSize(width: imageWidth, height: imageWidth)
            let image = await photoManager.loadImage(for: asset, targetSize: targetSize)
            cell.imageView.image = image
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let assets = albumData[indexPath.section]
        let asset = assets[indexPath.item]
        
        let fullScreenImageViewController = FullScreenImageViewController(asset: asset)
        navigationController?.pushViewController(fullScreenImageViewController, animated: true)
    }
}

// MARK: - Header View

extension RecommendViewController {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView
            .dequeueReusableSupplementaryView(ofKind: kind,
                                              withReuseIdentifier: CommonHeaderView.identifier,
                                              for: indexPath)
                as? CommonHeaderView else { return UICollectionReusableView() }
        
        var headLabel: String
        switch indexPath.section {
            case 0:
                headLabel = "나의 앨범"
            case 1:
                headLabel = "공유 앨범"
            case 2:
                headLabel = "동영상 앨범"
            default:
                headLabel = "디폴트"
        }
        headerView.configure(with: headLabel)
        return headerView
    }
}

// MARK: - 각 앨범 이미지 로딩

extension RecommendViewController {
    private func loadData() async {
        
        /// 나의 앨범
        let userAssets = await photoManager.fetchAssets(for: .userAlbum)
        albumData.append(userAssets)
        
        /// 공유앨범
        let sharedAssets = await photoManager.fetchAssets(for: .sharedAlbum)
        albumData.append(sharedAssets)
        
        /// 동영상
        let videoAssets = await photoManager.fetchAssets(for: .mediaType(.video))
        albumData.append(videoAssets)
    }
}
