//
//  ImageDiskCache.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 11.06.2025.
//

import UIKit

final class ImageDiskCache {
    static let shared = ImageDiskCache()
    
    private let fileManager = FileManager.default
    private let cacheDirectory: URL
    
    private init() {
        cacheDirectory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ImageDiskCache")
        
        if !fileManager.fileExists(atPath: cacheDirectory.path) {
            try? fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        }
    }
    
    private func fileName(for url: URL) -> String? {
        let allowed = CharacterSet.alphanumerics.union(.init(charactersIn: "-_"))
        return url.absoluteString.addingPercentEncoding(withAllowedCharacters: allowed)
    }
    
    func clear() async {
        let files = (try? fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)) ?? []
        for file in files {
            try? fileManager.removeItem(at: file)
        }
        print("Disk cache cleared")
    }
}

extension ImageDiskCache: Cachable {
    func image(for url: URL) async -> UIImage? {
        guard let key = fileName(for: url) else { return nil }
        let fileURL = cacheDirectory.appendingPathComponent(key)
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            return image
        }
        do {
            if let image = try await URLSession.shared.fetchImage(from: url),
               let data = image.pngData() {
                try? data.write(to: fileURL)
                return image
            }
        } catch {
            print("ImageDiskCache network error: \(error)")
        }
        return nil
    }
}
