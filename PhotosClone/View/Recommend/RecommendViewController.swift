//
//  RecommendViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/7.
//

import UIKit

class RecommendViewController: UIViewController {
    
    private lazy var myAlbumCollecionView: UICollectionView = {
        let layout = createPerSectionLayout()
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(RecommendCollectionViewCell.self, forCellWithReuseIdentifier: RecommendCollectionViewCell.identifier)
        myAlbumCollecionView.register(CommonHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CommonHeaderView.identifier)
       
        collectionView.backgroundColor = .white
        collectionView.alwaysBounceVertical = true
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureCollectionView()
        [myAlbumCollecionView].forEach { view.addAutoLayoutSubview($0) }
        myAlbumCollecionView.stretchToEdges(useSafeArea: true)
        
    }
    
    private func createPerSectionLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let columns = sectionIndex == 3 ? 1 : 2
            
            let itemWidth = (UIScreen.main.bounds.width - 12) / 2
            let itemHeight = itemWidth
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .estimated(itemWidth),
                                                  heightDimension: .estimated(itemHeight))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupWidth = UIScreen.main.bounds.width
            let groupHeight = groupWidth
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(groupWidth),
                                                   heightDimension: .estimated(groupHeight))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: columns)
            let section = NSCollectionLayoutSection(group: group)
            // Configure Header
            if sectionIndex < 4 { // Assuming you have 4 sections
                let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                        heightDimension: .absolute(44))
                
                let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                          elementKind: UICollectionView.elementKindSectionHeader,
                                                                          alignment: .top)
                section.boundarySupplementaryItems = [header]
            }
            
            
            
//            let layout = UICollectionViewCompositionalLayout(section: section)
            return section
        }
        return layout
    }
    
    private func configureCollectionView() {
        myAlbumCollecionView.dataSource = self
        myAlbumCollecionView.delegate = self
    }
}

enum SectionIndex {
    case album
    case shared
    case various
    case mediaType
    
    var index: Int {
        switch self {
            case .album: 0
            case .shared: 1
            case .various: 2
            case .mediaType: 3
        }
    }
    
    func numberOfColumns() -> Int {
        switch self {
        case .album, .shared, .various:
            return 2
        case .mediaType:
            return 1
        }
    }
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendCollectionViewCell.identifier, for: indexPath) as? RecommendCollectionViewCell else { return UICollectionViewCell() }
        
        
        switch indexPath.section {
            case 0:
                
                cell.albumTitleLabel.text = "앨범제목"
                
            case 1:
                cell.albumTitleLabel.text = "공유 앨범"
            case 2:
                cell.albumTitleLabel.text = "사람들, 반려동물 및 장소"
            case 3:
                cell.albumTitleLabel.text = "미디어유형"
            default:
                break
        }
        
        return cell
    }
}

extension RecommendViewController {
    func collectionView(_ collectionView: UICollectionView,
                         viewForSupplementaryElementOfKind kind: String,
                         at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                          withReuseIdentifier: CommonHeaderView.identifier,
                                                                               for: indexPath) as? CommonHeaderView else { return UICollectionReusableView() }
        
        var headLabel: String = ""
        switch indexPath.section {
        case 0:
                headLabel = "나의 앨범"
        case 1:
                headLabel = "공유 앨범"
        case 2:
                headLabel = "사람들, 반려동물 및 장소"
        case 3:
                headLabel = "미디어유형"
        default:
                break
        }
        
        headerView.configure(with: headLabel)
        return headerView
    }
}
