//
//  InfoPanelView.swift
//  Gesture
//
//  Created by Lucas de Castro Souza on 10/07/23.
//

import SwiftUI

struct InfoPanelView: View {
    var scale: CGFloat
    var offset: CGSize
    
    @State private var isInfoPanelVisible: Bool = false
    
    var body: some View {
        
        HStack {
            // MARK: - Icon

            Image(systemName: "circle.circle")
                .symbolRenderingMode(.hierarchical) // to see the diferent rendering modes of a symbol, use SFSymbols app
                .resizable()
                .frame(width: 30, height: 30)
                .onLongPressGesture(minimumDuration: 0.75) {
                    withAnimation(.easeOut) {
                        isInfoPanelVisible.toggle()
                    }
                }
            
            Spacer()
            
            // MARK: - Info Panel
            
            HStack(spacing: 2) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                Text("\(scale)")
                
                Spacer()
                
                Image(systemName: "arrow.left.and.right")
                Text("\(offset.width)")
                
                Spacer()
                
                Image(systemName: "arrow.up.and.down")
                Text("\(offset.height)")
            }
            .font(.footnote)
            .padding(8)
            .background(.ultraThinMaterial) // iOS 15 background to simulate glass
            .cornerRadius(8)
            .frame(maxWidth: 420)
            .opacity(isInfoPanelVisible ? 1 : 0)
            
            Spacer()
        }
    }
}

struct InfoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        InfoPanelView(scale: 1, offset: .zero)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
