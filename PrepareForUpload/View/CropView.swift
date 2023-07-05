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
        NavigationView {
            VStack {
                Spacer()
                ZStack {
                    Color.secondary
                        .frame(width: CropViewModel.frameWidth, height: CropViewModel.frameHeight)
                        .opacity(0.2)
                    ImageToCrop(viewModel: viewModel)
                        .border(.primary, width: 1)
                }
                Spacer()
                ZStack {
                    Color.secondary
                        .frame(maxWidth: .infinity, maxHeight: 60, alignment: .center)
                        .opacity(0.2)
                    HStack {
                        Button {
                            viewModel.reset()
                        } label: {
                            Label("Cancel", systemImage: "trash")
                        }
                        .padding()
                        Spacer()
                        Button {
                            print("crop")
                        } label: {
                            Label("Crop", systemImage: "crop")
                        }
                        .padding()
                    }
                }
            }
            .navigationBarTitle("Crop the Photo", displayMode: .inline)
        }
    }
}

struct CropeView_Previews: PreviewProvider {
    static var previews: some View {
            CropView(viewModel: CropViewModel(photo: Image("placeholder")))
    }
}
