//
//  ContentView.swift
//  Flick
//
//  Created by Vikram Rajpoot on 16/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import SwiftUI
import Combine


struct ContentView: View {
    @ObservedObject var vModel = PhotosListViewModel()
    @State var isOption = false
    @State var tileType = 2
    @State private var searchText:String = ""
    
    var tileSize: CGFloat {
        return CGFloat((UIScreen.main.bounds.size.width.toInt - tileType * 10 - 10) / tileType)
    }
    
    var body: some View {
        let finalData:[[Photo]] = vModel.photos.chunked(into: tileType)
        return NavigationView {
            ZStack{
                VStack {
                    TextField("Search here", text: $searchText, onCommit: self.fetchNextPage).padding().textFieldStyle(RoundedBorderTextFieldStyle())
                    List {
                        ForEach(finalData, id:\.self) { array in
                            HStack {
                                ForEach(array, id:\.self) { photo in
                                    VStack {
                                        if(photo.isEndIndex == true) {
                                            TileRow(photo: photo, size: self.tileSize).onAppear {
                                                self.vModel.updDateFetchedPage()
                                                self.fetchNextPage()
                                            }
                                        }else{
                                            TileRow(photo: photo, size: self.tileSize)
                                        }
                                    }
                                }
                            }
                        }
                    }.navigationBarTitle(Text("Photos")).foregroundColor(Color.red)
                        .navigationBarItems(trailing:
                            Button(action: {
                                self.isOption.toggle()
                            }) {
                                Image(systemName: "list.bullet")
                            }.actionSheet(isPresented: ($isOption), content: { () -> ActionSheet in
                                ActionSheet(title: Text("Select the tiles options"), message: Text(""), buttons: [ActionSheet.Button.default(Text("2"), action: {
                                    self.tileType = 2
                                }),ActionSheet.Button.default(Text("3"), action: {
                                    self.tileType = 3
                                    
                                }),ActionSheet.Button.default(Text("4"), action: {
                                    self.tileType = 4
                                })])
                            })
                    )
                }
                LoadingView(isLoading: vModel.isLoading)
            }
        }
    }
    
    func fetchNextPage(){
        vModel.fetchDataFromWebservice(searchTerm: searchText)
    }
    
}

struct TileRow : View {
    @State var photo: Photo
    @State var size:CGFloat
    var body: some View {
        ImageView(withURL: photo.imageURL(), photo: photo, id: photo.id, size: size)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
