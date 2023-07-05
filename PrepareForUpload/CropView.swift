//
//  CropView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 01/07/2023.
//

import SwiftUI

struct CropView: View {

    enum ImageValue {
        static let ratio: CGFloat = 3/4
        static let width: CGFloat = 350
        static let height: CGFloat = width * ratio
    }

    @State private var dragOffset: CGSize = .zero
    @State private var position: CGSize = .zero
    @State private var imageScale: CGFloat = 1

    var body: some View {
        Image("placeholder")
            .resizable()
            .scaledToFit()
            .padding(1)
            .scaleEffect(imageScale)
            .offset(x: dragOffset.width + position.width, y: dragOffset.height + position.height)
            .overlay(
                EmptyView()
                    .frame(width: ImageValue.width, height: ImageValue.height)
                    .border(.red, width: 1)
            )
            .frame(width: ImageValue.width, height: ImageValue.height)
            .clipped()

        // Double Tap Gesture
            .onTapGesture(count: 2) {
                withAnimation(.spring()) {
                    imageScale = 1
                    position = .zero
                }
            }

        // Drag Gesture
            .gesture(DragGesture()
                .onChanged{ value in
                    self.dragOffset = value.translation
                    self.fixPosition()
                }.onEnded{ value in
                    self.position.width += value.translation.width
                    self.position.height += value.translation.height
                    self.fixPosition()
                    self.dragOffset = .zero
                }
            )

        // Magnification Gesture
            .gesture(
                MagnificationGesture()
                    .onChanged{ value in
                        withAnimation(.spring()) {
                            if imageScale >= 1 && imageScale <= 3 {
                                imageScale = value
                            } else if imageScale > 3 {
                                imageScale = 3
                            } else if imageScale < 1 {
                                imageScale = 1
                            }
                        }
                    }
                    .onEnded{ value in
                        withAnimation(.spring()) {
                            if imageScale > 3 {
                                imageScale = 3
                            } else if imageScale < 1 {
                                imageScale = 1
                            }
                            self.fixPosition()
                        }
                    }
            )
    }

    private func fixPosition() {
        let widthLimit = ((ImageValue.width * imageScale) - ImageValue.width) / 2
        let heightLimit = ((ImageValue.height * imageScale) - ImageValue.height) / 2
        withAnimation(.spring()) {
            if self.position.width > widthLimit {
                self.position.width = widthLimit
            }
            if self.position.height > heightLimit {
                self.position.height = heightLimit
            }
            if self.position.width < -widthLimit {
                self.position.width = -widthLimit
            }
            if self.position.height < -heightLimit {
                self.position.height = -heightLimit
            }
        }
    }


}

struct CropeView_Previews: PreviewProvider {
    static var previews: some View {
        CropView()
    }
}
