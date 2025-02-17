//
//  Contacts.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import Foundation
import PhotosUI
import SwiftData
import SwiftUI


@Model
class Contact {
    
    var name: String
    
    @Attribute(.externalStorage) var photo: Data
    
    init(name: String, photo: Data) {
        self.name = name
        self.photo = photo
    }
    
    func getImage() -> Image? {
        if let uiImage = UIImage(data: photo) {
            return Image(uiImage: uiImage)
        } else {
            return nil
        }
    }
}
