//
//  FullScreenImageViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/9.
//

import UIKit
import Photos
import AVFoundation

class FullScreenImageViewController: UIViewController {
    
    private let asset: PHAsset
    private let imageManager = PHCachingImageManager()
    private let locationManager = LocationManager.shared
    private var player: AVPlayer?
    private let videoPlayerView = UIView()
    private var playerLayer: AVPlayerLayer?
    private var isPlaying = false
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    /// PHAsset로 FullScreenViewController를 로딩하기 위한 초기화
    init(asset: PHAsset) {
        self.asset = asset
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Life Cycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        imageView.frame = view.bounds
        videoPlayerView.frame = view.bounds
        
        [imageView, videoPlayerView].forEach { view.addAutoLayoutSubview($0) }
        loadAsset()
        setupTapGesture()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        isPlaying = false
        player?.pause()
    }
}

// MARK: - 이미지 로딩

extension FullScreenImageViewController: UIToolbarDelegate {
    
    /// 이미지의 가로/세로 여부에 따라 contentMode 변경
    private func updateContentMode(for image: UIImage?) {
        guard let image = image else {
            imageView.contentMode = .scaleAspectFill
            return
        }
        
        let imageSize = image.size
        if imageSize.width > imageSize.height {
            imageView.contentMode = .scaleAspectFit
        } else {
            imageView.contentMode = .scaleAspectFill
        }
    }
    
    private func loadImage() {
        let targetSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            if let self = self {
                self.imageView.image = image
                self.setupNavigationBar()
                self.videoPlayerView.isHidden = true
                self.imageView.isHidden = false
            }
        }
    }
    
    /// 미디어 타입에 따라 이미지 or 비디오 asset 로딩
    private func loadAsset() {
        let options = PHImageRequestOptions()
        options.isSynchronous = true
        
        if asset.mediaType == .image {
            loadImage()
        } else if asset.mediaType == .video {
            imageManager.requestAVAsset(forVideo: asset, options: nil) { [weak self] asset, _, _ in
                guard let asset = asset as? AVURLAsset else { return }
                
                Task {
                    self?.videoPlayerView.isHidden = false
                    self?.imageView.isHidden = true
                    self?.setupVideoPlayer(with: asset.url)
                }
            }
        }
    }
    
    private func setupVideoPlayer(with url: URL) {
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        
        if let playerLayer = playerLayer {
            playerLayer.frame = videoPlayerView.bounds
            playerLayer.videoGravity = .resizeAspect
            videoPlayerView.layer.addSublayer(playerLayer)
            videoPlayerView.layoutIfNeeded()
        }
        
        isPlaying = true
        player?.play()
        
    }
    
    // MARK: - Gesture 관련
    
    private func setupTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func handleTap() {
        guard asset.mediaType == .video else { return }
        
        if isPlaying {
            player?.pause()
        } else {
            player?.play()
        }
        isPlaying.toggle()
    }
}

// MARK: - UI
    
extension FullScreenImageViewController {
    private func setupUI() {
        view.backgroundColor = .systemBackground
        imageView.stretchToEdges(useSafeArea: true)
        videoPlayerView.stretchToEdges(useSafeArea: true)
    }
    
    private func setupNavigationBar() {
        Task {
            let locationTitle = await self.locationTitle()
            let date = dateTitle()
            
            let attributedString = NSMutableAttributedString()
            
            let locationAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
            ]
            let dateAttributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 14, weight: .regular)
            ]
            
            let locationString = NSAttributedString(string: locationTitle, attributes: locationAttributes)
            let dateString = NSAttributedString(string: "\n\(date)", attributes: dateAttributes)
            
            attributedString.append(locationString)
            attributedString.append(dateString)
            
            navigationItem.titleView =  {
                let titleLabel = UILabel()
                titleLabel.textAlignment = .center
                titleLabel.numberOfLines = 0
                titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
                titleLabel.adjustsFontSizeToFitWidth = true
                titleLabel.attributedText = attributedString
                return titleLabel
            }()
        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(backButtonTapped))
        
        let moreButton = UIBarButtonItem(image: UIImage(systemName: "ellipsis"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(moreButtonTapped))
        
        navigationItem.rightBarButtonItem = moreButton
        navigationController?.navigationBar.backgroundColor = .white
    }
    
    // MARK: - asset의 장소 및 날짜 출력
    
    private func locationTitle() async -> String {
        guard let latitude = asset.location?.coordinate.latitude,
              let longitude = asset.location?.coordinate.longitude else { return "알 수 없는 장소"
        }
        let address = await locationManager.reverseGeocode(latitude: latitude, longitude: longitude)
        return address
    }
    
    func dateTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        return formatter.string(from: asset.creationDate ?? Date())
    }
    
    // MARK: - 버튼 Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "복사", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "가리기", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "슬라이드쇼", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "앨범에 추가하기", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "날짜 수정하기", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "장소 수정하기", style: .default, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "삭제하기", style: .destructive, handler: { _ in self.showUnderDevelopmentAlert() }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in self.showUnderDevelopmentAlert() }))
        
        present(alert, animated: true, completion: nil)
    }

        
    @objc func showUnderDevelopmentAlert() {
        let alertController = UIAlertController(title: "알림",
                                                message: "기능을 준비중입니다.",
                                                preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "확인",
                                     style: .default,
                                     handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
