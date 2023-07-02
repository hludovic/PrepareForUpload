//
//  CropView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 01/07/2023.
//

import SwiftUI

struct CropView: View {

    @State private var imageScale: CGFloat = 1
    @State private var imageOffset: CGSize = .zero

    var body: some View {
        Image("placeholder")
            .resizable()
            .scaledToFit()
            .padding(1)
            .scaleEffect(imageScale)
            .offset(x: imageOffset.width, y: imageOffset.height)
            .overlay(
                EmptyView()
                    .frame(width: 350, height: 250, alignment: .center)
                    .border(.red, width: 1)
            )
            .frame(width: 350, height: 250, alignment: .center)
            .clipped()


        // Double Tap Gesture
            .onTapGesture(count: 2) {
                withAnimation(.spring()) {
                    imageScale = 1
                    imageOffset = .zero
                }
            }

        // Drag Gesture
            .gesture(
                DragGesture()
                    .onChanged{ value in
                        imageOffset = value.translation
                    }
                    .onEnded{ _ in
                        withAnimation(.spring()) {

                            if imageScale <= 1 {
                                imageOffset = .zero

                            }
                        }
                    }
            )

        // Magnification Gesture
            .gesture(
                MagnificationGesture()
                    .onChanged{ value in
                        withAnimation(.spring()) {
                            if imageScale >= 1/2 && imageScale <= 3 {
                                imageScale = value
                            } else if imageScale > 3 {
                                imageScale = 3
                            } else if imageScale < 1/2 {
                                imageScale = 1/2
                            }
                        }
                    }
                    .onEnded{ value in
                        withAnimation(.spring()) {
                            if imageScale > 3 {
                                imageScale = 3
                            } else if imageScale < 1/2 {
                                imageScale = 1/2
                            }
                        }
                    }
            )
    }
}

struct CropeView_Previews: PreviewProvider {
    static var previews: some View {
        CropView()
    }
}
