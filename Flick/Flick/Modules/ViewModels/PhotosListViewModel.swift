//
//  PhotosListViewModel.swift
//  Flick
//
//  Created by Vikram Rajpoot on 17/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class PhotosListViewModel: ObservableObject,Identifiable {
    var didChange = PassthroughSubject<PhotosListViewModel, Never>()
    let id = UUID()
    var page = 0
    @Published var photos  = [Photo]() {
        didSet{
            didChange.send(self)
        }
    }

    @Published  private(set) var isLoading = false {
        didSet {
            didChange.send(self)
        }
    }
    
    init() {
        //fetchDataFromWebservice(searchTerm: "s")
    }
    
    func fetchDataFromWebservice(searchTerm: String) {
        self.isLoading = true
        guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return
        }
        page += 1
        guard let nonNilUrl = URL(string: "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1&page=\(page)") else {
            return
        }
        print("current page:\(page)")
        VRWebservice().loadData(url: nonNilUrl) { (photos) in
            var tempData = [Photo]()
            if let nonNilPhotos = photos {
                tempData.append(contentsOf: nonNilPhotos)
                self.appendEndlInfo(models: &tempData)
            }
            self.isLoading = false
        }
    }
    
    func appendEndlInfo( models: inout [Photo]) {
        guard var lastModel = models.last else {
            return
        }
        lastModel.isEndIndex = true
        models[models.count - 1] = lastModel
        isLoading = false
        self.photos.append(contentsOf:models)

    }
    
    func updDateFetchedPage() {
        guard var lastModel = self.photos.last else {
           return
        }
        lastModel.isEndIndex = false
        self.photos[self.photos.count - 1] = lastModel

    }
    
}
