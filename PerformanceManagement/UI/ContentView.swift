//
//  ContentView.swift
//  PerformanceManagement
//
//  Created by Ulaş Sancak on 14.06.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                List {
                    NavigationLink("Memory Cache Demo", destination: ImagesView(cacher: ImageCache.shared))
                    NavigationLink("Disk Cache Demo", destination: ImagesView(cacher: ImageDiskCache.shared))
                    NavigationLink("Network Cache Demo", destination: ImagesView(cacher: NetworkCache.shared))
                }
                .navigationTitle("SwiftUI Demos")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("SwiftUI", systemImage: "swift")
            }
                
            NavigationStack {
                List {
                    NavigationLink("Memory Cache Demo", destination: ImageCollectionView(cacher: ImageCache.shared).navigationTitle("Cache Demo"))
                    NavigationLink("Disk Cache Demo", destination: ImageCollectionView(cacher: ImageDiskCache.shared).navigationTitle("Cache Demo"))
                    NavigationLink("Network Cache Demo", destination: ImageCollectionView(cacher: NetworkCache.shared).navigationTitle("Cache Demo"))
                }
                .navigationTitle("UIKit Demos")
                .navigationBarTitleDisplayMode(.inline)
            }
            .tabItem {
                Label("UIKit", systemImage: "square.grid.2x2")
            }
        }
    }
}

#Preview {
    ContentView()
}
