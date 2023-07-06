//
//  CropView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 01/07/2023.
//

import SwiftUI

struct CropView: View {
    @ObservedObject var viewModel: CropViewModel

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                ImageToCrop(viewModel: viewModel)
                Spacer()
                ZStack {
                    Color.white
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .bottom)
                        .opacity(0.1)
                    HStack {
                        Button {
                            viewModel.reset()
                            viewModel.isPresentedCropView = false
                        } label: {
                            Label("Cancel", systemImage: "trash")
                                .foregroundColor(.white)
                        }
                        .padding()
                        Spacer()
                        Button {
                            let render = ImageRenderer(content: ImageToCrop(viewModel: viewModel))
                            render.proposedSize = .init(CGSize(width: CropViewModel.frameWidth, height: CropViewModel.frameheight))
                            if let image = render.uiImage {
                                viewModel.cropedImage = image
                                viewModel.isPresentedCropView.toggle()
                            }
                            viewModel.reset()
                        } label: {
                            Label("Crop", systemImage: "crop")
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
            .background(.black)
            .navigationBarTitle("Crop the Photo", displayMode: .inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }
}

struct CropeView_Previews: PreviewProvider {
    static var previews: some View {
            CropView(viewModel: CropViewModel(photo: Image("previewImage")))
    }
}
