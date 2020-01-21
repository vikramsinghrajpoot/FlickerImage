//
//  Array.swift
//  Flick
//
//  Created by Vikram Rajpoot on 19/01/20.
//  Copyright © 2020 Vikram Rajpoot. All rights reserved.
//

import Foundation

extension Array {
    func chunked(into size:Int) -> [[Element]] {
        guard  self.count > 0 else {
            return [[]]
        }
        var chunkedArray = [[Element]]()
        for index in 0...self.count {
            if index % size == 0 && index != 0 {
                chunkedArray.append(Array(self[(index - size)..<index]))
            } else if(index == self.count) {
                chunkedArray.append(Array(self[index - 1..<index]))
            }
        }
        return chunkedArray
    }
}
