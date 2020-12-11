//
//  GIF.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import UIKit
import Foundation

struct GIF {
    
    // MARK: - Function
    // MARK: Public
    static func convert(data: Data?) -> UIImage? {
        guard let data = data, let source = CGImageSourceCreateWithData(data as CFData, nil) else { return nil }
        return animatedImageWithSource(source: source)
    }
    
    
    // MARK: Private
    static private func animatedImageWithSource(source: CGImageSource) -> UIImage? {
        let count  = CGImageSourceGetCount(source)
        var images = [CGImage]()
        var delays = [Int]()
        
        let downsampleOptions = [kCGImageSourceCreateThumbnailFromImageAlways : true,
                                 kCGImageSourceShouldCacheImmediately         : true,
                                 kCGImageSourceCreateThumbnailWithTransform   : true,
                                 kCGImageSourceThumbnailMaxPixelSize          : UIScreen.main.bounds.width] as CFDictionary
        
        for i in 0..<count {
            if let image = CGImageSourceCreateThumbnailAtIndex(source, i, downsampleOptions) {
                images.append(image)
            }
            
            let delaySeconds = delayForImageAtIndex(index: i, source: source)
            delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
        }
        
        let gcd        = gcdFor(array: delays)
        var frames     = [UIImage]()
        var frameCount = 0
        
        for i in 0..<count {
            frameCount = Int(delays[i] / gcd)
            
            for _ in 0..<frameCount {
                frames.append(UIImage(cgImage: images[i]))
            }
        }
        
        return UIImage.animatedImage(with: frames, duration: Double(delays.reduce(0) { $0 + $1 }) / 1000.0)
    }
    
    static private func delayForImageAtIndex(index: Int, source: CGImageSource) -> Double {
        var delay = 1.0
        
        let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
        guard let value = CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()) else { return delay }
        
        let gifProperties = unsafeBitCast(value, to: CFDictionary.self)
        var delayObject   = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
        
        if delayObject.doubleValue == 0 {
            delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
        }
        
        delay = delayObject as? Double ?? 0
        return min(1.0, delay)
    }
    
    static private func gcdFor(array: [Int]) -> Int {
        guard array.isEmpty == false else { return 1 }
        
        var gcd = array[0]
        for value in array {
            gcd = gcdForPair(value: value, gcd: gcd)
        }
        
        return gcd
    }
    
    static private func gcdForPair(value: Int, gcd: Int) -> Int {
        var value = value
        var gcd = gcd
        
        if value < gcd {
            let c = value
            value = gcd
            gcd = c
        }
        
        var rest = 0
        while true {
            rest = value % gcd
            
            guard rest != 0 else { return gcd }
            value = gcd
            gcd = rest
        }
    }
}
