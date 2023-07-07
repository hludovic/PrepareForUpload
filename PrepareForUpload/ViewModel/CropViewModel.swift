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
    static let frameWidth: CGFloat = 350
    static let frameheight: CGFloat = frameWidth * 3/4

    var imageOffset: CGSize {
        CGSize(width: dragOffset.width + position.width, height: dragOffset.height + position.height)
    }

    @Published var cropedImage: UIImage?
    @Published var selectedItem: PhotosPickerItem? {
        didSet { if selectedItem != nil { loadThePhoto() } }
    }
    @Published var photo: Image?
    @Published var dragOffset: CGSize = .zero
    @Published var position: CGSize = .zero
    @Published var imageScale: CGFloat = 1
    @Published var lastScale: CGFloat = 1
    @Published var isPresentedCropView: Bool = false
    @Published var isInteracting: Bool = false

    init(photo: Image? = nil) {
        if let photo { self.photo = photo }
    }

    func reset() {
        photo = nil
        dragOffset = .zero
        position = .zero
        imageScale = 1
    }

    func loadThePhoto() {
        Task {
            guard let selectedItem else { return print("Not Selected")}
            guard let data = try? await selectedItem.loadTransferable(type: Data.self) else { return print("ERROR1")}
            guard let uiImage = UIImage(data: data) else { return print("ERROR2") }
            await MainActor.run {
                photo = Image(uiImage: uiImage)
                isPresentedCropView = true
                self.selectedItem = nil
            }
            return
        }
    }

    func tapGesture() {
        withAnimation(.spring()) {
            imageScale = 1
            position = .zero
        }
    }

    func dragGesture() -> some Gesture {
        DragGesture()
            .onChanged{ value in
                self.isInteracting = true
                self.dragOffset = value.translation
            }.onEnded{ value in
                self.position.width += value.translation.width
                self.position.height += value.translation.height
                self.dragOffset = .zero
                self.isInteracting = false
            }
    }

    func magnificationGesture() -> some Gesture {
        MagnificationGesture()
            .onChanged{ value in
                self.isInteracting = true
                self.lastScale = value
            }
            .onEnded{ value in
                self.imageScale *= value
                self.lastScale = 1
                withAnimation(.spring()) {
                    if self.imageScale > 3 {
                        self.imageScale = 3
                    } else if self.imageScale < 1 {
                        self.imageScale = 1
                    }
                }
                self.isInteracting = false
            }
    }

    func fixPosition(size: CGSize) {
        let heightLimit = (((size.height * imageScale) - Self.frameheight)/2)
        let widthLimit = (((size.width  * imageScale) - Self.frameWidth)/2)
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
