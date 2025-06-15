//
//  NetworkCache.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 11.06.2025.
//

import Foundation
import UIKit

final class NetworkCache {
    static let shared = NetworkCache()
    
    private let session: URLSession
    
    private init() {
        let config = URLSessionConfiguration.default
        config.urlCache = URLCache(memoryCapacity: 50 * 1024 * 1024,
                                   diskCapacity: 200 * 1024 * 1024,
                                   diskPath: "URLCache")
        config.requestCachePolicy = .returnCacheDataElseLoad
        session = URLSession(configuration: config)
    }
}

extension NetworkCache: Cachable {
    func image(for url: URL) async -> UIImage? {
        do {
            let (data, _) = try await session.data(from: url)
            return UIImage(data: data)
        } catch {
            print("NetworkManager error: \(error)")
            return nil
        }
    }
}
