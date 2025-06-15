//
//  ImageCell.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 11.06.2025.
//

import UIKit

class ImageCell: UICollectionViewCell {
    private let photoImageView = UIImageView()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private var currentImageURL: URL?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = UIColor.gray.withAlphaComponent(0.3)
        photoImageView.layer.cornerRadius = 8
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(photoImageView)
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.color = .systemBlue
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(loadingIndicator)
                
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        photoImageView.image = nil
        loadingIndicator.stopAnimating()
        currentImageURL = nil
    }
    
    func configure(with imageURL: URL, cacher: Cachable = ImageDiskCache.shared) {
        currentImageURL = imageURL
        loadImage(from: imageURL, cacher: cacher)
    }
    
    private func loadImage(from url: URL, cacher: Cachable = ImageDiskCache.shared) {
        Task {
            await MainActor.run {
                guard self.currentImageURL == url else { return }
                self.loadingIndicator.startAnimating()
            }
            
            if let image = await cacher.image(for: url) {
                await MainActor.run {
                    guard self.currentImageURL == url else { return }
                    self.photoImageView.image = image
                    self.loadingIndicator.stopAnimating()
                }
            } else {
                await MainActor.run { 
                    guard self.currentImageURL == url else { return }
                    self.loadingIndicator.stopAnimating()
                }
            }
        }
    }
}
