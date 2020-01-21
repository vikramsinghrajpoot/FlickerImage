//
//  ImageDownloadManager.swift
//  FlickrTest
//
//  Created by Vikram Rajpoot on 17/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import UIKit

typealias VRImageDownloadHandler = (_ image: UIImage?, _ url: URL, _ id: String?, _ error: Error?) -> Void

final class VRImageDownloadManager {
    lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.vikramTest.imageDownloadqueue"
        queue.qualityOfService = .userInteractive
        queue.maxConcurrentOperationCount = 4
        return queue
    }()
    let imageCache = NSCache<NSString, UIImage>()
    static let shared = VRImageDownloadManager()
    private init () {}
    
    func downloadImage(_ flickrPhoto: Photo, id: String?, size: String = "m", handler: @escaping VRImageDownloadHandler) {
        guard let url = URL(string: flickrPhoto.imageURL()) else {
            return
        }
        if let cachedImage = imageCache.object(forKey: url.absoluteString as NSString) {
            handler(cachedImage, url, id, nil)
        } else {
            if let operations = (imageDownloadQueue.operations as? [VROperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
                operation.queuePriority = .veryHigh
            }else {
                let operation = VROperation(url: url, id: id)
                if id == nil {
                    operation.queuePriority = .high
                }
                operation.downloadHandler = { (image, url, id, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                        handler(image, url, id, error)
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    func slowDownImageDownloadTaskfor (_ flickrPhoto: Photo) {
        guard let url = URL(string: flickrPhoto.imageURL()) else {
            return
        }
        
        if let operations = (imageDownloadQueue.operations as? [VROperation])?.filter({$0.imageUrl.absoluteString == url.absoluteString && $0.isFinished == false && $0.isExecuting == true }), let operation = operations.first {
            operation.queuePriority = .low
        }
    }
    
    func cancelAll() {
        imageDownloadQueue.cancelAllOperations()
    }
    
}




