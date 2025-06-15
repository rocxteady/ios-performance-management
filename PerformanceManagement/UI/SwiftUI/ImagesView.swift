//
//  ImagesView.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 11.06.2025.
//

import SwiftUI

struct ImagesView: View {
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
        
    init(cacher: Cachable = ImageCache.shared) {
        self.cacher = cacher
    }
    
    var body: some View {
        VStack {            
            Text("Scroll through images. Second time loading should be instant (cached).")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding()
            
            ScrollView {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(imageURLs, id: \.self) { url in
                        AsyncImageView(url: url, cacher: cacher)
                            .frame(height: 150)
                            .clipped()
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            
            Button {
                Task {
                    await ImageCache.shared.clear()
                }

            } label: {
                Text("Clear Memory Cache")
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)
            }
            .buttonStyle(.bordered)
            .padding()
        }
        .navigationTitle("Cache Demo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ImagesView()
}
