//
//  ContentView.swift
//  Gesture
//
//  Created by Lucas de Castro Souza on 06/07/23.
//

import SwiftUI

struct ContentView: View {
    let screenHeight = UIScreen.main.bounds.height
    @State private var isAnimating: Bool = false
    @State private var imageScale: CGFloat = 1.0
    @State private var imageOffset: CGSize = .zero
    @State private var imageAngle: Angle = .zero
    @State private var isDrawerOpen: Bool = false
    
    let pages: [Page] = pagesData
    @State private var pageIndex: Int = 1
    
    var body: some View {
        NavigationView {
            ZStack {
                Color.clear
                
                Image(currentPage())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(10)
                    .shadow(color: .black.opacity(0.2), radius: 12, x: 2, y: 2)
                    .opacity(isAnimating ? 1 : 0)
                    .padding()
                    .offset(x: imageOffset.width, y: imageOffset.height) // modifiers orders matter in SwiftUI, therefore, offset should be before scaleEffect on porpose
                    .rotationEffect(imageAngle)
                    .scaleEffect(imageScale)
                    .onTapGesture(
                        count: 2 // that is how you implement a double tap gesture
                    ) {
                        if imageScale == 1 {
                            zoomImageIn()
                        } else {
                            resetImageState()
                        }
                    }
                    // MARK: - Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged() { gesture in
                                withAnimation(.spring()) {
                                    imageOffset = gesture.translation
                                }
                            }
                            .onEnded() { _ in
                                if imageScale <= 1 {
                                    resetImageState()
                                }
                            }
                    )
                    // MARK: - Magnification Gesture
                    .gesture(
                        MagnificationGesture()
                            .onChanged() { value in
                                if imageScale >= 1 && imageScale <= 5 {
                                    withAnimation(.spring()) {
                                        imageScale = value
                                    }
                                }
                            }
                            .onEnded() { _ in
                                if imageScale < 1 {
                                    resetImageState()
                                } else if imageScale > 5 {
                                    withAnimation(.spring()) {
                                        imageScale = 5
                                    }
                                }
                                
                            }
                    )
                // MARK: - Rotation Gesture
                // Does not work well with Magnification Gesture
                    .gesture(
                        RotationGesture()
                            .onChanged() { value in
                                imageAngle = value
                            }
                            .onEnded() { _ in
                                withAnimation(.spring()) {
                                    imageAngle = .zero
                                }
                            }
                    )


            }
            .navigationTitle("Pinch & Zoom")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear(perform: {
                withAnimation(.linear(duration: 1)) {
                    isAnimating = true
                }
            })
            // MARK: - InfoPanel
            .overlay(alignment: .top) {
                // TODO: - Find out how to disable animation effect when changing values in this component
                InfoPanelView(scale: imageScale, offset: imageOffset)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            // MARK: - Scale Control Buttons
            .overlay(alignment: .bottom) {
                Group {
                    HStack {
                        // MARK: - ScaleDownButton
                        Button {
                            if imageScale <= 1 {
                                resetImageState()
                            } else {
                                withAnimation(.spring()) {
                                    imageScale -= 1
                                }
                            }
                        } label: {
                            ControlImageView(type: .scaleDown)
                        }
                        // MARK: - ResetButton
                        Button {
                            resetImageState()
                        } label: {
                            ControlImageView(type: .reset)
                        }
                        // MARK: - ScaleUpButton
                        Button {
                            if imageScale < 5 {
                                withAnimation(.spring()) {
                                    imageScale += 1
                                }
                            } else {
                                imageScale = 5
                            }
                            
                        } label: {
                            ControlImageView(type: .scaleUp)
                        }
                    }
                    .padding(EdgeInsets(top: 12, leading: 20, bottom: 12, trailing: 20))
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .opacity(isAnimating ? 1 : 0)
                }
                .padding(.bottom, 30)
            }
            // MARK: - Drawer
            .overlay(alignment: .topTrailing) {
                HStack {
                    Image(systemName: isDrawerOpen ? "chevron.compact.right" : "chevron.compact.left")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 40)
                        .padding(8)
                        .foregroundStyle(.secondary)
                        .onTapGesture(perform: {
                            withAnimation(.easeOut) {
                                isDrawerOpen.toggle()
                            }
                        })
                    
                    Spacer()
                    
                    ForEach(pages) { page in
                        Image(page.thumbnailName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80)
                            .cornerRadius(8)
                            .shadow(radius: 4)
                            .opacity(isDrawerOpen ? 1 : 0)
                            .animation(.easeOut(duration: 0.5), value: isDrawerOpen)
                            .onTapGesture {
                                isAnimating = true
                                pageIndex = page.id
                            }
                    }
                    
                    Spacer()
                }
                .padding(EdgeInsets(top: 16, leading: 8, bottom: 16, trailing: 8))
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .opacity(isAnimating ? 1 : 0)
                .frame(width: 260)
                .padding(.top, screenHeight / 12)
                .offset(x: isDrawerOpen ? 20 : 215)
            }
        }
        .navigationViewStyle(.stack)// needed for navigation view not beeing in the lateral side bar on IPad.
    }
    
    private func zoomImageIn() {
        withAnimation(.spring()) {
            imageScale = 5
        }
    }
    
    private func zoomImageOut() {
        withAnimation(.spring()) {
            imageScale = 1
        }
    }
    
    private func resetImageState() {
        withAnimation(.spring()) {
            imageScale = 1
            imageOffset = .zero
        }
    }
    
    private func currentPage() -> String {
        pages[pageIndex - 1].imageName
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}
