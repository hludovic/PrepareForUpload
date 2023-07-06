//
//  ImageToCrop.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 04/07/2023.
//

import SwiftUI

struct ImageToCrop: View {
    @ObservedObject var viewModel: CropViewModel
    @State var isInteracting: Bool = false
    
    var body: some View {
        ImageView()
            .frame (maxWidth: .infinity, maxHeight: .infinity)
    }

    @ViewBuilder func ImageView() -> some View {
            if let photo = viewModel.photo {
                photo
                    .resizable()
                    .scaledToFill()
                    .overlay {
                        GeometryReader { geometry in
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.spring()) {
                                        viewModel.fixPosition(size: geometry.size)
                                    }
                                }
                        }
                    }
                    .frame(width: CropViewModel.frameWidth, height: CropViewModel.frameheight, alignment: .center)
                    .scaleEffect(viewModel.imageScale * viewModel.lastScale)
                    .offset(viewModel.imageOffset)
                    .clipped()
                // MARK: - Drag Gesture
                    .gesture(
                        DragGesture()
                            .onChanged{ value in
                                isInteracting = true
                                viewModel.dragOffset = value.translation
                            }.onEnded{ value in
                                viewModel.position.width += value.translation.width
                                viewModel.position.height += value.translation.height
                                viewModel.dragOffset = .zero
                                isInteracting = false
                            }
                    )
                // MARK: - Magnification Gesture
                    .gesture(
                        MagnificationGesture()
                            .onChanged{ value in
                                    isInteracting = true
                                    viewModel.lastScale = value
                            }
                            .onEnded{ value in
                                viewModel.imageScale *= value
                                viewModel.lastScale = 1
                                withAnimation(.spring()) {
                                    if viewModel.imageScale > 3 {
                                        viewModel.imageScale = 3
                                    } else if viewModel.imageScale < 1 {
                                        viewModel.imageScale = 1
                                    }
                                }
                                isInteracting = false
                            }
                    )
                // MARK: - Double tap gesture
                    .onTapGesture(count: 2) {
                        withAnimation(.spring()) {
                            viewModel.imageScale = 1
                            viewModel.position = .zero
                        }
                    }
            }
    }
}

struct ImageToCrop_Previews: PreviewProvider {
    static var previews: some View {
        ImageToCrop(viewModel: CropViewModel(photo: Image("previewImage")))
    }
}
