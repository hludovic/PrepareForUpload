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
                    .frame(width: 350, height: 350, alignment: .center)
                    .scaleEffect(viewModel.imageScale)
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
                                withAnimation(.spring()) {
                                    isInteracting = true
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
        ImageToCrop(viewModel: CropViewModel(photo: Image("placeholder")))
//            .border(.primary, width: 1)
    }
}
