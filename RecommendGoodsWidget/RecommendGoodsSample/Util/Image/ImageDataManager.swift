//
//  ImageDataManager.swift
//  Bookshelf
//
//  Created by Den Jo on 2020/10/19.
//

import UIKit
import Foundation
import MobileCoreServices
import Photos
import Vision

final class ImageDataManager: NSObject {
    
    // MARK: - Singleton
    static let shared = ImageDataManager()
    private override init() { super.init() }    // This prevents others from using the default initializer for this calls
    
    
    // MARK: - Value
    // MARK: Private
    private lazy var imageCache = NSCache<NSString, UIImage>()
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.httpMaximumConnectionsPerHost = 90
        configuration.timeoutIntervalForRequest     = 90.0
        configuration.timeoutIntervalForResource    = 90.0
        return URLSession(configuration: configuration)
    }()
    
    private var downloadTasks = [ImageURL : URLSessionDataTask]()
    private let accessQueue   = DispatchQueue(label: "ImageDataManagerAccessQueue")
    
    private lazy var uploadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "UploadQueue"
        queue.maxConcurrentOperationCount = 10
        return queue
    }()
    
    
    // MARK: - Function
    // MARK: Public
    func download(url: ImageURL?, completion: ((_ url: ImageURL?, _ image: UIImage?) -> Void)? = nil) {
        guard let imageURL = url else {
            completion?(url, nil)
            return
        }
        
        accessQueue.async {
            // If the cached image exist, return the image
            if let cachedImage = self.imageCache.object(forKey: imageURL.absoluteString) {
                completion?(imageURL, cachedImage)
                return
            }
            
            
            // Download image
            let task = self.downloadSession.dataTask(with: URLRequest(url: imageURL)) { (data, response, error) in
                guard let data = data, error == nil else { return }
                let image = (response?.url?.lastPathComponent.lowercased().hasSuffix("gif") == true ? GIF.convert(data: data) : UIImage(data: data))
                
                // Cache
                self.accessQueue.async {
                    if let image = image, let urlString = url?.absoluteString {
                        self.imageCache.setObject(image, forKey: urlString as NSString)
                    }
                    
                    completion?(imageURL, image)
                    self.downloadTasks.removeValue(forKey: imageURL)
                }
            }
           
            // Cache
            self.downloadTasks[imageURL] = task
            task.resume()
        }
    }
    
    func cancelDownload(url: ImageURL?) {
        accessQueue.async {
            guard let url = url else { return }
            self.downloadTasks[url]?.cancel()
            self.downloadTasks.removeValue(forKey: url)
        }
    }
    
    func cancelDownload(urls: [ImageURL]) {
        guard urls.isEmpty == false else { return }
        
        accessQueue.async {
            urls.forEach {
                self.downloadTasks[$0]?.cancel()
                self.downloadTasks.removeValue(forKey: $0)
            }
        }
    }
}

