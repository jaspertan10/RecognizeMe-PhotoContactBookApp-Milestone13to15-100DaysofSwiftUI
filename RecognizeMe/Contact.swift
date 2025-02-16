//
//  Contacts.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import Foundation
import PhotosUI
import _PhotosUI_SwiftUI
import SwiftUICore


@Observable
class Contact: Identifiable {
    
    var name: String
    var pickerItem: PhotosPickerItem
    var selectedImage: Image
    
    init(name: String, pickerItem: PhotosPickerItem, selectedImage: Image) {
        self.name = name
        self.pickerItem = pickerItem
        self.selectedImage = selectedImage
    }
}
