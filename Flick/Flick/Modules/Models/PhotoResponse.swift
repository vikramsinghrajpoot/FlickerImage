//
//  PhotoResponse.swift
//  Flick
//
//  Created by Vikram Rajpoot on 17/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation

struct Photo:Codable,Identifiable, Hashable {
    let title:String
    let owner:String?
    let secret:String
    let server:String
    let farm:Int
    let id: String
    var isEndIndex: Bool?
}

struct Photos:Codable, Identifiable {
    let photo:[Photo]
    let id = UUID()
}

struct PhotoResponse:Codable {
    let photos: Photos
}

extension Photo {
    func imageURL(_ size:String = "m") -> String {
        let url = "https://farm\(farm).staticflickr.com/\(server)/\(id)_\(secret)_\(size).jpg"
        return url
    }
}
