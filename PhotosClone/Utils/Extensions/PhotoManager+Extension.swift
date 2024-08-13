//
//  AlbumType.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/10.
//

import Photos

extension PhotoManager {
    
    enum AlbumType {
        case userAlbum
        case sharedAlbum
        case mediaType(MediaType)
        
        enum MediaType {
            /// PHAssetMediaType.video 에서 가져오기
            case video
            case photoLive
            
            /// slowmotion
            case photoHDR
            case photoPanorama
            case videoTimelapse
            case videoCinematic
            case photoScreenshot
            
            var subTypesName: String {
                switch self {
                    case .video: "비디오"
                    case .photoLive: "Live Photo"
                    case .photoHDR: "슬로 모션"
                    case .photoPanorama: "파노라마"
                    case .videoTimelapse: "타임랩스"
                    case .videoCinematic: "시네마틱"
                    case .photoScreenshot: "스크린샷"
                        
                }
            }
        }
        
        var index: Int {
            switch self {
                case .userAlbum: 0
                case .sharedAlbum: 1
                case .mediaType: 2
            }
        }
        
        func numberOfColumns() -> Int {
            switch self {
            case .userAlbum, .sharedAlbum:
                return 2
            case .mediaType:
                return 1
            }
        }
        
        func mediaTypeToPHAssetMediaType(_ mediaType: AlbumType.MediaType) -> PHAssetMediaType {
            switch mediaType {
            case .video, .videoTimelapse, .videoCinematic:
                return .video
            case .photoLive, .photoHDR, .photoPanorama, .photoScreenshot:
                return .image
            }
        }

    }
 
    func allMediaSubtypes() -> [Int] {
        return [
            Int(PHAssetMediaSubtype.videoStreamed.rawValue),
            Int(PHAssetMediaSubtype.videoHighFrameRate.rawValue),
            Int(PHAssetMediaSubtype.videoTimelapse.rawValue),
            Int(PHAssetMediaSubtype.photoLive.rawValue),
            Int(PHAssetMediaSubtype.photoDepthEffect.rawValue),
            Int(PHAssetMediaSubtype.photoPanorama.rawValue),
            Int(PHAssetMediaSubtype.photoHDR.rawValue),
            Int(PHAssetMediaSubtype.photoScreenshot.rawValue)
        ]
    }
}
