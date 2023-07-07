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

    @Published var selectedItem: PhotosPickerItem? {
        didSet { if selectedItem != nil { loadCropedPhoto() } }
    }
    @Published var cropedPhoto: UIImage?
    @Published var selectedPhoto: Image?
    @Published var dragOffset: CGSize = .zero
    @Published var position: CGSize = .zero
    @Published var imageScale: CGFloat = 1
    @Published var lastScale: CGFloat = 1
    @Published var isPresentedCropView: Bool = false
    @Published var isInteracting: Bool = false
    @Published var displayAlert: Bool = false
    var alertMessage = ""
    

    func pressCancelButton() {
        resetPhotoToCropParameters()
        isPresentedCropView = false
    }

    func pressCropButton() {
        Task {
            await MainActor.run {
                let render = ImageRenderer(content: ImageToCrop(viewModel: self))
                render.proposedSize = .init(CGSize(width: CropViewModel.frameWidth, height: CropViewModel.frameheight))
                if let image = render.uiImage {
                    cropedPhoto = image
                    isPresentedCropView.toggle()
                }
                resetPhotoToCropParameters()
            }
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

extension CropViewModel {
    // MARK: - Gestures Methods
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
}

private extension CropViewModel {
    // MARK: - Private Methods
    func resetPhotoToCropParameters() {
        selectedPhoto = nil
        dragOffset = .zero
        position = .zero
        imageScale = 1
    }

    func alertError(message: String) {
        Task {
            await MainActor.run {
                alertMessage = message
                displayAlert = true
            }
        }
    }

    func loadCropedPhoto() {
        Task {
            guard let selectedItem else {
                return alertError(message: "No photo has been selected")
            }
            guard let data = try? await selectedItem.loadTransferable(type: Data.self) else {
                return alertError(message: "Can't work with the selected photo")
            }
            guard let uiImage = UIImage(data: data) else {
                return alertError(message: "Unable to load the selected photo")
            }
            await MainActor.run {
                selectedPhoto = Image(uiImage: uiImage)
                isPresentedCropView = true
                self.selectedItem = nil
            }
            return
        }
    }
}
