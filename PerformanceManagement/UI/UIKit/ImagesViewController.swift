//
//  ImagesViewController.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 14.06.2025.
//

import UIKit

class ImagesViewController: UIViewController {
    private let cacher: Cachable
    
    private let imageURLs = [
        "https://picsum.photos/300/300?random=1",
        "https://picsum.photos/300/300?random=2",
        "https://picsum.photos/300/300?random=3",
        "https://picsum.photos/300/300?random=4",
        "https://picsum.photos/300/300?random=5",
        "https://picsum.photos/300/300?random=6",
        "https://picsum.photos/300/300?random=7",
        "https://picsum.photos/300/300?random=8",
        "https://picsum.photos/300/300?random=9",
        "https://picsum.photos/300/300?random=10",
        "https://picsum.photos/300/300?random=11",
        "https://picsum.photos/300/300?random=12",
        "https://picsum.photos/300/300?random=13",
        "https://picsum.photos/300/300?random=14",
        "https://picsum.photos/300/300?random=15",
        "https://picsum.photos/300/300?random=16",
        "https://picsum.photos/300/300?random=17",
        "https://picsum.photos/300/300?random=18",
        "https://picsum.photos/300/300?random=19",
        "https://picsum.photos/300/300?random=20"
    ].compactMap { URL(string: $0) }
    
    private var collectionView: UICollectionView!
    
    init(cacher: Cachable = ImageCache.shared) {
        self.cacher = cacher
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        cacher = ImageCache.shared
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupUI()
    }
    
    private func setupUI() {
        // Create description label  
        let descriptionLabel = UILabel()
        descriptionLabel.text = "Scroll through images. Second time loading should be instant (cached)."
        descriptionLabel.font = .systemFont(ofSize: 13)
        descriptionLabel.textColor = .secondaryLabel
        descriptionLabel.textAlignment = .center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        setupCollectionView()
        
        let clearCacheButton = UIButton(type: .system)
        clearCacheButton.translatesAutoresizingMaskIntoConstraints = false
        
        var config = UIButton.Configuration.bordered()
        config.title = "Clear Disk Cache"
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 17)
            return outgoing
        }
        clearCacheButton.configuration = config
        clearCacheButton.addTarget(self, action: #selector(clearCacheButtonTapped), for: .touchUpInside)
        
        view.addSubview(descriptionLabel)
        view.addSubview(clearCacheButton)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            collectionView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: clearCacheButton.topAnchor, constant: -16),
            
            clearCacheButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            clearCacheButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            clearCacheButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            clearCacheButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
        let screenWidth = UIScreen.main.bounds.width
        let availableWidth = screenWidth - 32 - 10 // padding + spacing
        let itemWidth = availableWidth / 2
        layout.itemSize = CGSize(width: itemWidth, height: 150)
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        
        view.addSubview(collectionView)
    }
    
    @objc private func clearCacheButtonTapped() {
        Task {
            await ImageDiskCache.shared.clear()
        }
    }
}

extension ImagesViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let url = imageURLs[indexPath.item]
        cell.configure(with: url, cacher: cacher)
        return cell
    }
} 

#Preview {
    UINavigationController(rootViewController: ImagesViewController())
}

import SwiftUI

struct ImageCollectionView: UIViewControllerRepresentable {
    private let cacher: Cachable
    
    init(cacher: Cachable = ImageCache.shared) {
        self.cacher = cacher
    }
    
    func makeUIViewController(context: Context) -> ImagesViewController {
        return ImagesViewController(cacher: cacher)
    }
    
    func updateUIViewController(_ uiViewController: ImagesViewController, context: Context) {}
}
