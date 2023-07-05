//
//  CropViewModel.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 04/07/2023.
//

import Foundation
import SwiftUI
import _PhotosUI_SwiftUI

class CropViewModel: ObservableObject {

    static private let ratio: CGFloat = 3/4
    static let frameWidth: CGFloat = 350
    static let frameHeight: CGFloat = frameWidth * ratio

    var imageOffset: CGSize {
        CGSize(width: dragOffset.width + position.width, height: dragOffset.height + position.height)
    }

    @Published var selectedItem: PhotosPickerItem? {
        didSet { loadThePhoto() }
    }
    @Published var photo: Image?
    @Published var dragOffset: CGSize = .zero
    @Published var position: CGSize = .zero
    @Published var imageScale: CGFloat = 1
    @Published var isPresentedCropView: Bool = false

    init(photo: Image? = nil) {
        if let photo { self.photo = photo }
    }

    func reset() {
        photo = nil
        dragOffset = .zero
        position = .zero
        imageScale = 1
        selectedItem = nil
        isPresentedCropView = false
    }

    func loadThePhoto() {
        Task {
            guard let data = try? await selectedItem?.loadTransferable(type: Data.self) else { return print("ERROR")}
            guard let uiImage = UIImage(data: data) else { return print("ERROR") }
            await MainActor.run {
                photo = Image(uiImage: uiImage)
                isPresentedCropView = true
            }
            return
        }
    }

    func fixPosition() {
        let widthLimit = ((Self.frameWidth * imageScale) - Self.frameWidth) / 2
        let heightLimit = ((Self.frameHeight * imageScale) - Self.frameHeight) / 2
        if self.position.width > widthLimit {
            self.position.width = widthLimit
        }
        if self.position.height > heightLimit {
            self.position.height = heightLimit
        }
        if self.position.width < -widthLimit {
            self.position.width = -widthLimit
        }
        if self.position.height < -heightLimit {
            self.position.height = -heightLimit
        }
    }


}
