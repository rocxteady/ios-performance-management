# PerformanceManagement

This Xcode project demonstrates and compares three different image caching strategies in iOS:

- **Memory cache** (using NSCache)
- **Disk cache** (file-based, persistent)
- **URLCache** (built-in HTTP cache)

The goal is to help you understand how each cache works, their trade-offs, and how to use them in real apps. Each cache type is implemented as a separate, swappable class with a clean async API.

## Features

- **Memory Cache**: Fastest, but only lasts while the app is open. Uses NSCache.
- **Disk Cache**: Stores images on disk, so they persist between launches. Uses percent-encoded URLs for file names.
- **URLCache**: Uses iOS's built-in HTTP cache, respects server cache headers, and works automatically with URLSession.
- **SwiftUI and UIKit demos**: Try each cache type in both UI frameworks. The UI is kept consistent for fair comparison.
- **Easy to swap**: All cache classes conform to a simple `Cachable` protocol, so you can switch strategies with one line of code.

## How to Run

1. Open `PerformanceManagement.xcodeproj` in Xcode (latest version recommended).
2. Select a simulator or your device.
3. Build and run. Use the UI to test each cache type and see the difference in performance.

## Learn More

For a step-by-step explanation and code walkthrough, check out the LinkedIn Pulse article:

[Read the full tutorial on LinkedIn Pulse](https://www.linkedin.com/pulse/why-caching-matters-ios-performance-modern-swift-examples-ula%C5%9F-sancak-hyb3f)

---

Feel free to use or adapt the code for your own projects. If you have questions or suggestions, open an issue or leave a comment on the LinkedIn Pulse! 