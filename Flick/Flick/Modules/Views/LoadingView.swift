//
//  LoadingView.swift
//  SwiftUI-List-Pagination
//
//  Created by Vikram Rajpoot on 17/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import SwiftUI

struct LoadingView: UIViewRepresentable {

    var isLoading: Bool

    func makeUIView(context: Context) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(frame: .zero)
        indicator.style = .large
        indicator.hidesWhenStopped = true
        return indicator
    }

    func updateUIView(_ view: UIActivityIndicatorView, context: Context) {
        if self.isLoading {
            view.startAnimating()
        } else {
            view.stopAnimating()
        }
    }
}

#if DEBUG
struct LoadingView_Previews : PreviewProvider {
    static var previews: some View {
        LoadingView(isLoading: true)
    }
}
#endif

