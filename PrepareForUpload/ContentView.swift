//
//  ContentView.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 29/06/2023.
//

import SwiftUI
import PhotosUI

struct ContentView: View {
    @State private var selectedItem: PhotosPickerItem?
    @State private var photo: Image?

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")

            PhotosPicker("Select a photo", selection: $selectedItem, matching: .images)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
