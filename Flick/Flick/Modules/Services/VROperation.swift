//
//  PGOperation.swift
//  FlickrTest
//
//  Created by Vikram Rajpoot on 17/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import UIKit

class VROperation: Operation {
    var downloadHandler: VRImageDownloadHandler?
    var imageUrl: URL!
    private var id: String?
    
    override var isAsynchronous: Bool {
        get {
            return  true
        }
    }
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    required init (url: URL, id: String?) {
        self.imageUrl = url
        self.id = id
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        //Asynchronous logic (eg: n/w calls) with callback
        self.downloadImageFromUrl()
    }
    
    func downloadImageFromUrl() {
        let newSession = URLSession.shared
        let downloadTask = newSession.downloadTask(with: self.imageUrl) { (location, response, error) in
            if let locationUrl = location, let data = try? Data(contentsOf: locationUrl){
                let image = UIImage(data: data)
                    self.downloadHandler?(image,self.imageUrl, self.id,error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
    
}
