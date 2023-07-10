//
//  ZoomControlImageButton.swift
//  Gesture
//
//  Created by Lucas de Castro Souza on 10/07/23.
//

import SwiftUI

enum ControlImageViewType {
    case scaleDown
    case reset
    case scaleUp
}

struct ControlImageView: View {
    
    var type: ControlImageViewType
    
    var body: some View {
        ZStack {
            switch type {
            case .scaleDown:
                Image(systemName: "minus.magnifyingglass")
            case .reset:
                Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
            case .scaleUp:
                Image(systemName: "plus.magnifyingglass")
            }
        }.font(.system(size: 36))
    }
    
}

struct ControlImageView_Previews: PreviewProvider {
    static var previews: some View {
        ControlImageView(type: .reset)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
