//
//  CacheAsyncImage.swift
//  WeatherApp
//
//  Created by Arghadeep Chakraborty on 9/22/24.
//

import SwiftUI

struct CacheAsyncImage<Content>: View where Content: View {
    
    private let url: URL?
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content
        
    init(url: URL?,
         scale: CGFloat = 1.0,
         transaction: Transaction = Transaction(),
         @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.url = url
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }
    
    var body: some View {
        if let cached = ImageCache[url ?? URL(fileURLWithPath: "")] {
            let _ = print("cached \(url?.absoluteString)")
            content(.success(cached))
        } else {
            let _ = print("request \(url?.absoluteString)")
            AsyncImage(url: url, scale: scale, transaction: transaction) { phase in
                cacheAndRender(phase: phase)
            }
        }
    }
    
    func cacheAndRender(phase: AsyncImagePhase) -> some View {
        if case .success(let image) = phase {
            ImageCache[url ?? URL(fileURLWithPath: "")] = image
        }
        return content(phase)
    }
}

#Preview {
    CacheAsyncImage(url: URL(string: "https://openweathermap.org/img/wn/10d@2x.png")!) { phase in
        switch phase {
        case .empty:
            ProgressView()
        case .success(let image):
            image
        case .failure(let error):
            Text("\(error.localizedDescription)")
        @unknown default:
            fatalError()
        }
    }
}

fileprivate class ImageCache {
    static private var cache: [URL: Image] = [:]
    
    static subscript(url: URL) -> Image? {
        get {
            ImageCache.cache[url]
        }
        set {
            ImageCache.cache[url] = newValue
        }
    }
}
