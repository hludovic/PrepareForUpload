//
//  CropView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 01/07/2023.
//

import SwiftUI

struct CropView: View {
    @StateObject var viewModel = CropViewModel()

    var body: some View {
        ZStack {
            Color.gray
                .frame(width: CropViewModel.frameWidth, height: CropViewModel.frameHeight)
                .opacity(0.5)
            ImageToCrop(viewModel: viewModel)
                .frame(width: CropViewModel.frameWidth, height: CropViewModel.frameHeight)
                .clipped()
                .border(.gray, width: 2)
        }
    }
}

struct CropeView_Previews: PreviewProvider {
    static var previews: some View {
        CropView()
    }
}
