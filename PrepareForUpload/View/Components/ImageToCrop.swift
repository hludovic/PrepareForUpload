//
//  ImageToCrop.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 04/07/2023.
//

import SwiftUI

struct ImageToCrop: View {
    @ObservedObject var viewModel: CropViewModel
    var body: some View {
        // MARK: - dragGesture property
        let dragGesture = DragGesture()
            .onChanged{ value in
                viewModel.dragOffset = value.translation
                withAnimation(.spring()) {
                    viewModel.fixPosition()
                }
            }.onEnded{ value in
                viewModel.position.width += value.translation.width
                viewModel.position.height += value.translation.height
                withAnimation(.spring()) {
                    viewModel.fixPosition()
                }
                viewModel.dragOffset = .zero
            }

        // MARK: - magnificationGesture property
        let magnificationGesture = MagnificationGesture()
            .onChanged{ value in
                withAnimation(.spring()) {
                    if viewModel.imageScale >= 1 && viewModel.imageScale <= 3 {
                        viewModel.imageScale = value
                    } else if viewModel.imageScale > 3 {
                        viewModel.imageScale = 3
                    } else if viewModel.imageScale < 1 {
                        viewModel.imageScale = 1
                    }
                }
            }
            .onEnded{ value in
                withAnimation(.spring()) {
                    if viewModel.imageScale > 3 {
                        viewModel.imageScale = 3
                    } else if viewModel.imageScale < 1 {
                        viewModel.imageScale = 1
                    }
                    viewModel.fixPosition()
                }
            }

        // MARK: - Image property
        Image("placeholder")
            .resizable()
            .scaledToFit()
            .padding(1)
            .scaleEffect(viewModel.imageScale)
            .offset(viewModel.imageOffset)
            .gesture(dragGesture)
            .gesture(magnificationGesture)
            .onTapGesture(count: 2) {
                withAnimation(.spring()) {
                    viewModel.imageScale = 1
                    viewModel.position = .zero
                }
            }
    }
}

struct ImageToCrop_Previews: PreviewProvider {
    static var previews: some View {
        ImageToCrop(viewModel: CropViewModel())

    }
}
