//
//  AsyncImageView.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 15.06.2025.
//

import SwiftUI

struct AsyncImageView: View {
    let url: URL
    private let cacher: Cachable
    @State private var image: UIImage?
    @State private var isLoading = false
    
    init(url: URL, cacher: Cachable = ImageCache.shared) {
        self.url = url
        self.cacher = cacher
    }

    var body: some View {
        Group {
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .overlay(
                        ProgressView()
                            .opacity(isLoading ? 1 : 0)
                    )
            }
        }
        .onAppear { loadImage() }
    }
    
    private func loadImage() {
        Task {
            await MainActor.run { 
                self.image = nil
                isLoading = true 
            }
            
            // Use the simplified cache API - handles everything internally
            if let downloaded = await cacher.image(for: url) {
                await MainActor.run {
                    self.image = downloaded
                    isLoading = false
                }
            } else {
                await MainActor.run { isLoading = false }
            }
        }
    }
} 

#Preview {
    AsyncImageView(url: URL(string: "https://picsum.photos/300/300?random=1")!)
        .frame(width: 300, height: 300)
}
