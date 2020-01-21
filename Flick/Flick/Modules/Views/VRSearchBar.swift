//
//  VRSearchBar.swift
//  Flick
//
//  Created by Vikram Rajpoot on 19/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation
import SwiftUI

struct VRSearchBar: UIViewRepresentable {
    @Binding var text:String

    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text:String
        
        init(text:Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
        
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            
        }
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> VRSearchBar.Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<VRSearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<VRSearchBar>) {
        uiView.text = text
    }
    
}
