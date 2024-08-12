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
        case people
        case animals
        case places
        case mediaType(MediaType)
        
        enum MediaType {
            case video
            case selfie
            case livePhoto
            case portrait
            case longExposure
            case panorama
            case timelapse
            case sloMo
            case cinematic
            case burst
            case screenshot
            case screenRecording
            case animated
        }
    }
    
    func mediaTypeToPHAssetMediaType(_ mediaType: AlbumType.MediaType) -> PHAssetMediaType {
        switch mediaType {
        case .video: return .video
        case .selfie: return .image
        case .livePhoto: return .image
        case .portrait: return .image
        case .longExposure: return .image
        case .panorama: return .image
        case .timelapse: return .video
        case .sloMo: return .video
        case .cinematic: return .video
        case .burst: return .image
        case .screenshot: return .image
        case .screenRecording: return .video
        case .animated: return .image
        }
    }
}
