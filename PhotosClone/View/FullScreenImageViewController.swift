//
//  FullScreenImageViewController.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/9.
//

import UIKit
import Photos

class FullScreenImageViewController: UIViewController {
    
    private let asset: PHAsset
    private let imageManager = PHCachingImageManager()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return imageView
    }()
    
    /// For loading FullScreenImageViewController using PHAsset
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
        view.addSubview(imageView)
        loadImage()
        setupConstraints()
        setupNavigationBar()
        setupToolbar()
        navigationController?.isToolbarHidden = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.setToolbarHidden(true, animated: true)
    }
}

// MARK: - Methods

extension FullScreenImageViewController: UIToolbarDelegate {
    
    private func setupConstraints() {
        
    }
    
    private func loadImage() {
        let targetSize = CGSize(width: view.bounds.width, height: view.bounds.height)
        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: nil) { [weak self] image, _ in
            self?.imageView.image = image
        }
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        imageView.stretchToEdges(useSafeArea: false)
    }
    
    private func setupNavigationBar() {
        navigationItem.titleView = {
            let titleLabel = UILabel()
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 2
            titleLabel.text = "장소 \n시간"
            return titleLabel
        }()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        let moreButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(moreButtonTapped)
        )
        
        let editButton = UIBarButtonItem(
            title: "Edit",
            style: .plain,
            target: self,
            action: #selector(editButtonTapped)
        )
        
        navigationItem.rightBarButtonItems = [moreButton, editButton]
    }
    
    private func setupToolbar() {
        if let navCon = navigationController {
            navCon.toolbar.backgroundColor = .white
        }
        
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action,
                                          target: self,
                                          action: #selector(shareButtonTapped))
        
        let likeButton = UIBarButtonItem(image: UIImage(systemName: "heart"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(likeButtonTapped))
        
        let infoButton = UIBarButtonItem(image: UIImage(systemName: "info.circle"),
                                         style: .plain,
                                         target: self,
                                         action: #selector(infoButtonTapped))
        
        let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash,
                                           target: self,
                                           action: #selector(deleteButtonTapped))
        
        
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)

        navigationController?.toolbarItems = [shareButton, flexibleSpace, likeButton, flexibleSpace, infoButton, flexibleSpace, deleteButton]
        print("toolbar is showed")
    }
    
    private func locationTitle() -> String {
        return "Location Name"
    }
    
    private func dateTitle() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 HH:mm"
        return formatter.string(from: asset.creationDate ?? Date())
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func moreButtonTapped() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Copy", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Duplicate", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Hide", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Slideshow", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add to Album", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Move to Archive", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Adjust Date & Time", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Adjust Location", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc private func editButtonTapped() {
        
        print("Edit button tapped")
    }
    
    @objc private func shareButtonTapped() {
        print("Share button tapped")
        
    }
    
    @objc private func likeButtonTapped() {
        
        print("Like button tapped")
    }
    
    @objc private func infoButtonTapped() {
        
        print("Info button tapped")
    }
    
    @objc private func deleteButtonTapped() {
        
        print("Delete button tapped")
    }
}
