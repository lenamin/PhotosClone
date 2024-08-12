//
//  PhotoManager.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

/*
import Photos

class PhotoManager {
    static let shared = PhotoManager()
    
    private init() { }
    
    
     func loadAssets(for dateRange: DateRange) {
     Task {
     var assets: [PHAsset] = []
     let photoManager = PhotoManager.shared
     let fetchResult = photoManager.fetchAsset(for: dateRange)
     assets = fetchResult.objects(at: IndexSet(0..<fetchResult.count))
     print("Fetched assets count: \(assets.count)")
     //            collectionView.reloadData()
     }
     }
     */
    
    /*
     func fetchGroupDateAssets(for dateGroupRange: DateGroupRange) -> [Date: [PHAsset]] {
     let fetchOptions = PHFetchOptions()
     let calendar = Calendar.current
     
     let startDate, endDate: Date
     
     switch dateGroupRange {
     case .day(let date):
     startDate = calendar.startOfDay(for: date)
     endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? Date()
     fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
     
     case .month(let date):
     let components = calendar.dateComponents([.year, .month], from: date)
     startDate = calendar.date(from: components) ?? Date()
     endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
     fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
     
     case .year(let date):
     let components = calendar.dateComponents([.year], from: date)
     startDate = calendar.date(from: components) ?? Date()
     endDate = calendar.date(byAdding: .year, value: 1, to: startDate) ?? Date()
     fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
     
     case .range(let start, let end):
     startDate = calendar.startOfDay(for: start)
     endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) ?? Date()
     fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
     
     }
     
     fetchOptions.sortDescriptors = [
     NSSortDescriptor(key: "creationDate", ascending:  true)
     ]
     let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     var groupedAssets = [Date: [PHAsset]]()
     
     fetchResult.enumerateObjects { asset, _, _ in
     if let creationDate = asset.creationDate {
     let groupDate: Date
     switch dateGroupRange {
     case .day:
     groupDate = calendar.startOfDay(for: creationDate)
     
     case .month:
     let components = calendar.dateComponents([.year, .month], from: creationDate)
     groupDate = calendar.date(from: components) ?? Date()
     
     case .year:
     let components = calendar.dateComponents([.year], from: creationDate)
     groupDate = calendar.date(from: components) ?? Date()
     
     case .range:
     groupDate = calendar.startOfDay(for: creationDate)
     }
     
     if groupedAssets[groupDate] == nil {
     groupedAssets[groupDate] = []
     }
     groupedAssets[groupDate]?.append(asset)
     print("PhotoManager에서 groupedAssets[groupDate]?.append(asset)을 했다: \(groupedAssets)")
     }
     }
     
     return groupedAssets
     }
     
     /*
      /// "연", "월", "일" 기간에 따른 asset을 fetch
      func fetchAsset(for dateRange: DateRange) -> PHFetchResult<PHAsset> {
      let fetchOptions = PHFetchOptions()
      let calendar = Calendar.current
      
      fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
      
      switch dateRange {
      case .day(let date):
      let startOfDay = calendar.startOfDay(for: date)
      let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay) ?? Date()
      fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startOfDay, endOfDay])
      
      case .month(let date):
      let components = calendar.dateComponents([.year, .month], from: date)
      
      let startOfMonth = calendar.date(from: components) ?? Date()
      let endOfMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth) ?? Date()
      fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startOfMonth, endOfMonth])
      
      case .year(let date):
      let components = calendar.dateComponents([.year], from: date)
      
      let startOfYear = calendar.date(from: components) ?? Date()
      let endOfYear = calendar.date(byAdding: .year, value: 1, to: startOfYear) ?? Date()
      fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startOfYear, endOfYear])
      
      case .all:
      fetchOptions.predicate = nil
      }
      
      
      return PHAsset.fetchAssets(with: fetchOptions)
      }
      */
     
     // MARK: - FOR YOU 추천 컨텐츠
     func fetchSmartAlbums() -> PHFetchResult<PHAssetCollection> {
     let fetchOptions = PHFetchOptions()
     fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
     
     return PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .any, options: fetchOptions)
     }
     
     func fetchAssets(for albumType: AlbumType) async -> [PHAsset] {
     let fetchOptions = PHFetchOptions()
     var fetchResult: PHFetchResult<PHAsset>
     
     fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
     
     switch albumType {
     case .userAlbum:
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     
     case .sharedAlbum:
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     case .people:
     fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     case .animals:
     fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     case .places:
     fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.image.rawValue)
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     case .mediaType(let mediaType):
     fetchOptions.predicate = NSPredicate(format: "mediaType == %d", mediaTypeToPHAssetMediaType(mediaType).rawValue)
     fetchResult = PHAsset.fetchAssets(with: fetchOptions)
     }
     
     return await withCheckedContinuation { continuation in // 비동기작업 완료를 처리 (continuation 객체를 매개변수로 받는다)
     var assets: [PHAsset] = [] // 자산을 저장할 빈배열
     fetchResult.enumerateObjects { (asset, _, _) in
     assets.append(asset)
     }
     continuation.resume(returning: assets) // 비동기 작업 완료하고 결괍 ㅏㄴ환
     }
     }
     
     */
    /*
    // 모든 사진의 촬영일 범위를 결정
    func fetchDateRange() -> (startDate: Date, endDate: Date)? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchOptions.fetchLimit = 1
        
        guard let earliestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            return nil
        }
        print("fetchDateRange== earliestAsset: \(String(describing: earliestAsset.creationDate))")
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        guard let latestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            return nil
        }
        print("fetchDateRange ==latestAsset: \(String(describing: latestAsset.creationDate))")
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: earliestAsset.creationDate ?? Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: latestAsset.creationDate ?? Date())) ?? Date()
        print("fetchDateRange ==날짜범위계산에서: \(startDate) ~ \(endDate)")
        return (startDate, endDate)
    }
    
    // 주어진 날짜 범위에 따라 사진을 그룹화하여 반환
    func fetchGroupDateAssets(for dateGroupRange: DateGroupRange) -> [Date: [PHAsset]] {
        guard let dateRange = fetchDateRange() else { return [:] }
        print("fetchGroupDateAssets에서 dateRange== \(dateRange)")
        
        let fetchOptions = PHFetchOptions()
        let calendar = Calendar.current
        
        let startDate: Date
        let endDate: Date
        
        switch dateGroupRange {
            case .day(let date):
                startDate = calendar.startOfDay(for: date)
                endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? Date()
                
            case .month(let date):
                let components = calendar.dateComponents([.year, .month], from: date)
                startDate = calendar.date(from: components) ?? Date()
                endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
                
            case .year(let date):
                let components = calendar.dateComponents([.year], from: date)
                startDate = calendar.date(from: components) ?? Date()
                endDate = calendar.date(byAdding: .year, value: 1, to: startDate) ?? Date()
                
            case .range(let start, let end):
                startDate = calendar.startOfDay(for: start)
                endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) ?? Date()
        }
        
        fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        var groupedAssets = [Date: [PHAsset]]()
        
        fetchResult.enumerateObjects { asset, _, _ in
            guard let creationDate = asset.creationDate else { return }
            
            let groupDate: Date
            switch dateGroupRange {
            case .day:
                groupDate = calendar.startOfDay(for: creationDate)
                
            case .month:
                let components = calendar.dateComponents([.year, .month], from: creationDate)
                groupDate = calendar.date(from: components) ?? Date()
                
            case .year:
                let components = calendar.dateComponents([.year], from: creationDate)
                groupDate = calendar.date(from: components) ?? Date()
                
            case .range:
                groupDate = calendar.startOfDay(for: creationDate)
            }
            
            if groupedAssets[groupDate] == nil {
                groupedAssets[groupDate] = []
            }
            groupedAssets[groupDate]?.append(asset)
            print("fetchGroupDateAssets== groupedAssets: \(groupedAssets.keys), \(groupedAssets.count)")
        }
        
        return groupedAssets
    }
    
}
*/
/*
import Photos
class PhotoManager {
    
    static let shared = PhotoManager()
    
    private init() { }
    
    
    // 모든 사진의 촬영일 범위를 결정
    func fetchDateRange() -> (startDate: Date, endDate: Date)? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchOptions.fetchLimit = 1
        
        // Earliest photo
        guard let earliestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil
        }
        print("o Earliest asset creation date: \(String(describing: earliestAsset.creationDate))")
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        // Latest photo
        guard let latestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil
        }
        print("o Latest asset creation date: \(String(describing: latestAsset.creationDate))")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: earliestAsset.creationDate ?? Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: latestAsset.creationDate ?? Date())) ?? Date()
        print("o Date range from fetchDateRange: \(startDate) to \(endDate)")
        return (startDate, endDate)
    }
    
    func fetchGroupDateAssets(for dateGroupRange: DateGroupRange) -> [Date: [PHAsset]] {
        guard let dateRange = fetchDateRange() else { return [:] }
        print("=====NEWMETHODS : Date range used in fetchGroupDateAssets: \(dateRange.startDate) ~ \(dateRange.endDate)")
        
        let fetchOptions = PHFetchOptions()
        let calendar = Calendar.current
        
        let startDate: String
        let endDate: String
        
        switch dateGroupRange {
            case .day(let date):
                if #available(iOS 15.0, *) {
                    startDate = dateRange.startDate.formatted(date: .abbreviated, time: .omitted)
                    endDate = dateRange.endDate.formatted(date: .abbreviated, time: .omitted)
                    print("Fetching assets for day: \(startDate) to \(endDate)")
                }
                
                
                
            case .month(let date):
                let components = calendar.dateComponents([.year, .month], from: date)
//                startDate = calendar.date(from: components) ?? Date()
//                endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
//                print("Fetching assets for month: \(startDate) to \(endDate)")
                
            case .year(let date):
                let components = calendar.dateComponents([.year], from: date)
//                startDate = calendar.date(from: components) ?? Date()
//                endDate = calendar.date(byAdding: .year, value: 1, to: startDate) ?? Date()
//                print("Fetching assets for year: \(startDate) to \(endDate)")
                
            case .range(let start, let end): break
//                startDate = calendar.startOfDay(for: start)
//                endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) ?? Date()
//                print("Fetching assets for range: \(startDate) to \(endDate)")
        }
        
//        fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [startDate, endDate])
        fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange)
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        print("??? Fetched NUMBER \(fetchResult.count) assets.")
        
        var groupedAssets = [Date: [PHAsset]]()
        print("??? groupedAssets.keys: \(groupedAssets.keys)")
        
        fetchResult.enumerateObjects { asset, _, _ in
            guard let creationDate = asset.creationDate else { return }
            
            let groupDate: Date
            switch dateGroupRange {
            case .day:
                groupDate = calendar.startOfDay(for: creationDate)
                
            case .month:
                let components = calendar.dateComponents([.year, .month], from: creationDate)
                groupDate = calendar.date(from: components) ?? Date()
                
            case .year:
                let components = calendar.dateComponents([.year], from: creationDate)
                groupDate = calendar.date(from: components) ?? Date()
                
            case .range:
                groupDate = calendar.startOfDay(for: creationDate)
            }
            
            if groupedAssets[groupDate] == nil {
                groupedAssets[groupDate] = []
            }
            groupedAssets[groupDate]?.append(asset)
//            print("Added asset to group date: \(groupDate)")
        }
        
        print("Grouped assets: \(groupedAssets.keys), count: \(groupedAssets.count)")
        return groupedAssets
    }

}
*/

import Photos

class PhotoManager {
    init () {}
    static let shared = PhotoManager()
    
//    
//    func fetchGroupDateAssets(for dateGroupRange: DateGroupRange) -> [Date: [PHAsset]] {
//        guard let dateRange = fetchDateRange() else { return [:] }
//        print("=====NEWMETHODS : Date range used in fetchGroupDateAssets: \(dateRange.startDate) ~ \(dateRange.endDate)")
//        
//        let fetchOptions = PHFetchOptions()
//        let calendar = Calendar.current
//        
//        let startDate: Date
//        let endDate: Date
//        
//        switch dateGroupRange {
//            case .day(let date):
//                startDate = calendar.startOfDay(for: date)
//                endDate = calendar.date(byAdding: .day, value: 1, to: startDate) ?? Date()
//                print("Fetching assets for day: \(startDate) to \(endDate)")
//                
//            case .month(let date):
//                let components = calendar.dateComponents([.year, .month], from: date)
//                startDate = calendar.date(from: components) ?? Date()
//                endDate = calendar.date(byAdding: .month, value: 1, to: startDate) ?? Date()
//                print("Fetching assets for month: \(startDate) to \(endDate)")
//                
//            case .year(let date):
//                let components = calendar.dateComponents([.year], from: date)
//                startDate = calendar.date(from: components) ?? Date()
//                endDate = calendar.date(byAdding: .year, value: 1, to: startDate) ?? Date()
//                print("Fetching assets for year: \(startDate) to \(endDate)")
//                
//            case .range(let start, let end):
//                startDate = calendar.startOfDay(for: start)
//                endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: end)) ?? Date()
//                print("Fetching assets for range: \(startDate) to \(endDate)")
//        }
//        
//        // Adjust the date range to ensure it falls within the global range
//        let globalStartDate = max(startDate, dateRange.startDate)
//        let globalEndDate = min(endDate, dateRange.endDate)
//        print("Global date range used for fetch: \(globalStartDate) to \(globalEndDate)")
//        
//        fetchOptions.predicate = NSPredicate(format: PreficateFormats.dateRange, argumentArray: [globalStartDate, globalEndDate])
//        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
//        
//        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
//        print("??? Fetched NUMBER \(fetchResult.count) assets.")
//        
//        var groupedAssets = [Date: [PHAsset]]()
//        
//        fetchResult.enumerateObjects { asset, _, _ in
//            guard let creationDate = asset.creationDate else { return }
//            
//            let groupDate: Date
//            switch dateGroupRange {
//            case .day:
//                groupDate = calendar.startOfDay(for: creationDate)
//                
//            case .month:
//                let components = calendar.dateComponents([.year, .month], from: creationDate)
//                groupDate = calendar.date(from: components) ?? Date()
//                
//            case .year:
//                let components = calendar.dateComponents([.year], from: creationDate)
//                groupDate = calendar.date(from: components) ?? Date()
//                
//            case .range:
//                groupDate = calendar.startOfDay(for: creationDate)
//            }
//            
//            if groupedAssets[groupDate] == nil {
//                groupedAssets[groupDate] = []
//            }
//            groupedAssets[groupDate]?.append(asset)
//            print("Added asset to group date: \(groupDate)")
//        }
//        
//        print("Grouped assets: \(groupedAssets.keys.sorted()), count: \(groupedAssets.count)")
//        return groupedAssets
//    }

}

extension PhotoManager {
    
    // 모든 사진의 촬영일 범위를 결정
    func fetchDateRange() -> (startDate: Date, endDate: Date)? {
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        fetchOptions.fetchLimit = 1
        
        // Earliest photo
        guard let earliestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil
        }
        print("o Earliest asset creation date: \(String(describing: earliestAsset.creationDate))")
        
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1
        
        // Latest photo
        guard let latestAsset = PHAsset.fetchAssets(with: fetchOptions).firstObject else {
            print("No assets found.")
            return nil
        }
        print("o Latest asset creation date: \(String(describing: latestAsset.creationDate))")
        
        let calendar = Calendar.current
        let startDate = calendar.startOfDay(for: earliestAsset.creationDate ?? Date())
        let endDate = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: latestAsset.creationDate ?? Date())) ?? Date()
        print("o Date range from fetchDateRange: \(startDate) to \(endDate)")
        return (startDate, endDate)
    }
    
    func fetchRangeDateAssets(for dateMode: DateMode) -> [Date: [PHAsset]] {
        guard let dateRange = fetchDateRange() else { return [:] }
        print("=====NEWMETHODS : Date range used in fetchGroupDateAssets: \(dateRange.startDate) ~ \(dateRange.endDate)")
        
        let fetchOptions = PHFetchOptions()
        let calendar = Calendar.current
        
        let globalStartDate: Date
        let globalEndDate: Date
        
        switch dateMode {
        case .day(let date):
            globalStartDate = calendar.startOfDay(for: date)
            globalEndDate = calendar.date(byAdding: .day, value: 1, to: globalStartDate) ?? globalStartDate
            fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", globalStartDate as NSDate, globalEndDate as NSDate)
            
        case .month(let date):
            let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
            globalStartDate = startOfMonth
            globalEndDate = calendar.date(byAdding: .month, value: 1, to: startOfMonth) ?? startOfMonth
            fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", globalStartDate as NSDate, globalEndDate as NSDate)
            
        case .year(let date):
            let startOfYear = calendar.date(from: calendar.dateComponents([.year], from: date))!
            globalStartDate = startOfYear
            globalEndDate = calendar.date(byAdding: .year, value: 1, to: startOfYear) ?? startOfYear
            fetchOptions.predicate = NSPredicate(format: "creationDate >= %@ AND creationDate < %@", globalStartDate as NSDate, globalEndDate as NSDate)
        }

        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
        
        let fetchResult = PHAsset.fetchAssets(with: fetchOptions)
        print("??? Fetched NUMBER \(fetchResult.count) assets.")
        
        var groupedAssets = [Date: [PHAsset]]()

        // 자산을 날짜별로 그룹화합니다
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

}
