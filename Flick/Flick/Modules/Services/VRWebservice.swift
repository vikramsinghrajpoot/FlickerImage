//
//  WebService.swift
//  Flick
//
//  Created by Vikram Rajpoot on 16/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

let apiKey = "de24642a8668fb0318ec5b9cecfda18c"

class VRWebservice {
    typealias Completion =  ([Photo]?)->()
    func loadData(url:URL, completion:@escaping Completion){
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let nonNilData = data else {
                completion(nil)
                return
            }
            let response = try? JSONDecoder().decode(PhotoResponse.self, from: nonNilData)
            if let nonNilResponse = response {
                DispatchQueue.main.async {
                    completion(nonNilResponse.photos.photo)
                }
            }else{
                print("Error")
            }
            
        }.resume()
    }
}
