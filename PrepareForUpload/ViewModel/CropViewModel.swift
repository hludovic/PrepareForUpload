//
//  CropViewModel.swift
//  PrepareForUpload
//
//  Created by Ludovic HENRY on 04/07/2023.
//

import Foundation

class CropViewModel: ObservableObject {

    static private let ratio: CGFloat = 3/4
    static let frameWidth: CGFloat = 350
    static let frameHeight: CGFloat = frameWidth * ratio

    var imageOffset: CGSize {
        CGSize(width: dragOffset.width + position.width, height: dragOffset.height + position.height)
    }

    @Published var dragOffset: CGSize = .zero
    @Published var position: CGSize = .zero
    @Published var imageScale: CGFloat = 1

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
