//
//  ImageCache.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 11.06.2025.
//

import Foundation
import UIKit

final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    private init() {
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100 // 100MB
    }
    
    func cachedImage(for key: String) async -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }
    
    func setImage(_ image: UIImage, for key: String) async {
        let cost = image.jpegData(compressionQuality: 1.0)?.count ?? 0
        cache.setObject(image, forKey: NSString(string: key), cost: cost)
    }
    
    func removeImage(for key: String) async {
        cache.removeObject(forKey: NSString(string: key))
    }
    
    func clear() async {
        cache.removeAllObjects()
        print("Memory cache cleared")
    }
}

extension ImageCache: Cachable {
    func image(for url: URL) async -> UIImage? {
        let key = url.absoluteString
        if let cached = cache.object(forKey: key as NSString) {
            return cached
        }
        // Networkten çek ve cache'e yaz
        do {
            if let image = try await URLSession.shared.fetchImage(from: url) {
                cache.setObject(image, forKey: key as NSString)
                return image
            }
        } catch {
            print("ImageCache network error: \(error)")
        }
        return nil
    }
}
