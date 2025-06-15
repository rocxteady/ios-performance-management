//
//  URLSession+UIImage.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 15.06.2025.
//

import UIKit

extension URLSession {
    func fetchImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await self.data(from: url)
        return UIImage(data: data)
    }
}
