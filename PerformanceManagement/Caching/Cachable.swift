//
//  Cachable.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 14.06.2025.
//

import UIKit.UIImage

protocol Cachable {
    func image(for url: URL) async -> UIImage?
}
