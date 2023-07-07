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
                            viewModel.pressCancelButton()
                        } label: {
                            Label("Cancel", systemImage: "trash")
                                .foregroundColor(.white)
                        }
                        .padding()
                        Spacer()
                        Button {
                            viewModel.pressCropButton()
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
    static func previewVM() -> CropViewModel {
        let vm = CropViewModel()
        let photo = Image("previewImage")
        vm.selectedPhoto = photo
        return vm
    }

    static var previews: some View {
        CropView(viewModel: previewVM())
    }
}
