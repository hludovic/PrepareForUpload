//
//  ContentView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 29/06/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @StateObject var viewModel = CropViewModel()

    var body: some View {
        VStack {
            if let crop = viewModel.cropedPhoto {
                Image(uiImage: crop)
            }
            PhotosPicker("Select a photo", selection: $viewModel.selectedItem, matching: .images)
        }
        .sheet(isPresented: $viewModel.isPresentedCropView) {
            CropView(viewModel: viewModel)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
