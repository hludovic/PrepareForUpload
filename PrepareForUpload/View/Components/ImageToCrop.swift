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
        if let photo = viewModel.selectedPhoto {
            photo
                .resizable()
                .scaledToFill()
                .overlay {
                    GeometryReader { geometry in
                        Color.clear
                            .onChange(of: viewModel.isInteracting) { newValue in
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
                .gesture(viewModel.dragGesture())
                .gesture(viewModel.magnificationGesture())
                .onTapGesture(count: 2) {viewModel.tapGesture()}
        }
    }
}


struct ImageToCrop_Previews: PreviewProvider {
    static var previews: some View {
        ImageToCrop(viewModel: CropViewModel(photo: Image("previewImage")))
    }
}
