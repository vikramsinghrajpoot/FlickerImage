//
//  ImageView.swift
//  SwiftUIApi
//
//  Created by Vikram Rajpoot on 31/12/19.
//  Copyright © 2019 Vikram Rajpoot. All rights reserved.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    fileprivate var didChange = PassthroughSubject<UIImage, Never>()
    private var photo:Photo
    private var id:String
    fileprivate var image = UIImage() {
        didSet {
            didChange.send(image)
        }
    }
    
    init(urlString:String, photo:Photo, id: String) {
        self.id = id
        self.photo = photo
        VRImageDownloadManager.shared.downloadImage(photo, id: id) { (image, _, _, _) in
            guard let nonNilImage = image else { return }
            DispatchQueue.main.async {
                self.image = nonNilImage
            }
        }
    }
}

struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage(named: "no_image")!
    private var photo:Photo
    private var id:String
    private var size:CGFloat
    
    init(withURL url:String, photo:Photo, id: String, size: CGFloat) {
        self.id = id
        imageLoader = ImageLoader(urlString:url, photo: photo, id: self.id)
        self.photo = photo
        self.size = size
    }
    
    var body: some View {
        VStack {
            Image(uiImage: image)
                .resizable()
                .frame(width:size, height: size)
                .aspectRatio(contentMode: .fit)
            
        }.onReceive(imageLoader.didChange) { image in
            self.image = image
        }
    }
}

