//
//  PageModel.swift
//  Gesture
//
//  Created by Lucas de Castro Souza on 10/07/23.
//

import Foundation

struct Page: Identifiable {
    let id: Int
    let imageName: String
}

extension Page {
    var thumbnailName: String {
        return "thumb-" + imageName
    }
}
