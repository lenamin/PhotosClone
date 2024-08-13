//
//  PhotoManager.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import UIKit.UIImage
import Photos

class PhotoManager {
    
    static let shared = PhotoManager()
    
    /// 모든 사진의 촬영일 범위를 결정하여 fetchRangeDateAssets() 메서드에서 호출됨
    /// - Returns:
    /// startDate: creationDate의 시작점
    /// endDate: creationDate의 끝점
    func fetchDateRange() -> (startDate: Date, endDate: Date)? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchOptions.fetchLimit = 1
        
        // Earliest Photo
        guard let earliestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil
        }
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        // Latest Photo
        guard let latestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil }
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: earliestAsset.creationDate ?? Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: latestAsset.creationDate ?? Date())) ?? Date()
        print("o Date range from fetchDateRange: \(startDate) to \(endDate)")
        return (startDate, endDate)
    }
    
    /// DateMode에 따라 각 일자별 / 월별 / 연별 PHAsset을 Grouping
    func fetchRangeDateAssets(for dateMode: DateMode) -> [Date: [PHAsset]] {
        guard let dateRange = fetchDateRange() else { return [:] }
        print("Date range used in fetchGroupDateAssets: \(dateRange.startDate) ~ \(dateRange.endDate)")
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", dateRange.startDate as NSDate, dateRange.endDate as NSDate)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]

        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        print("Fetched NUMBER \(fetchResult.count) assets.")
        
        var groupedAssets = [Date: [PHAsset]]()
        let calendar = Calendar.current
        
        fetchResult.enumerateObjects { asset, _, _ in
            let creationDate = asset.creationDate ?? Date()
            let calendarComponents: DateComponents
            
            switch dateMode {
            case .day:
                calendarComponents = calendar.dateComponents([.year, .month, .day], from: creationDate)
            case .month:
                calendarComponents = calendar.dateComponents([.year, .month], from: creationDate)
            case .year:
                calendarComponents = calendar.dateComponents([.year], from: creationDate)
            }
            
            let keyDate = calendar.date(from: calendarComponents) ?? Date()
            
            if groupedAssets[keyDate] == nil {
                groupedAssets[keyDate] = []
            }
            
            groupedAssets[keyDate]?.append(asset)
        }
        
        return groupedAssets
    }
    
    
    // MARK: - FOR YOU 추천 컨텐츠
    
    func fetchSmartAlbums() -> PHFetchResult<PHAssetCollection> {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
    }
    
    func fetchAssets(for albumType: AlbumType) async -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        var fetchResult: PHFetchResult<PHAssetCollection>
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        switch albumType {
            case .userAlbum:
                fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular, options: nil)
                
            case .sharedAlbum:
                fetchResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumCloudShared, options: nil)
            case .mediaType(let mediaType):
                fetchResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: nil)
                fetchOptions.predicate = NSPredicate(format: "mediaType == %d", albumType.mediaTypeToPHAssetMediaType(mediaType).rawValue)
        }
        var assets: [PHAsset] = []
        
        fetchResult.enumerateObjects { collection, _, _ in
            let assetFetchResult = PHAsset.fetchAssets(in: collection, options: fetchOptions)
            assetFetchResult.enumerateObjects { asset, _, _ in
                assets.append(asset)
            }
        }
        return await withCheckedContinuation { continuation in
            continuation.resume(returning: assets)   
        }
    }
    
    func loadImage(for asset: PHAsset, targetSize: CGSize) async -> UIImage? {
        await withCheckedContinuation { continuation in
            let requestOptions = PHImageRequestOptions()
            requestOptions.isSynchronous = true
            
            let imageManager = PHCachingImageManager()
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: requestOptions) { image, _ in
                continuation.resume(returning: image)
            }
        }
    }
    
    /// 미디어 타입에 따른 이미지 Fetching
    func fetchAssets(for mediaSubtype: PHAssetMediaSubtype) async -> [PHAsset] {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaSubtypes == %d", mediaSubtype.rawValue)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var assets: [PHAsset] = []
        
        fetchResult.enumerateObjects { asset, _, _ in
            assets.append(asset)
        }
        
        return await withCheckedContinuation { continuation in
            continuation.resume(returning: assets)
        }
    }
    
    func fetchAllAssetsForSubtypes() async -> [Int: [PHAsset]] {
        var assetsBySubtype: [Int: [PHAsset]] = [:]
        let subtypes = allMediaSubtypes()
        
        for subtypeRawValue in subtypes {
            let subtype = PHAssetMediaSubtype(rawValue: UInt(subtypeRawValue))
            let assets = await fetchAssets(for: subtype)
            assetsBySubtype[subtypeRawValue] = assets
        }
        return assetsBySubtype
    }
}
