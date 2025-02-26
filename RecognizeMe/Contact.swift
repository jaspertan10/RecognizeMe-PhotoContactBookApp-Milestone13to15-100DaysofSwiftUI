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


struct Coordinate2D: Codable {
    let latitude: Double
    let longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(_ location: CLLocationCoordinate2D) {
        self.latitude = location.latitude
        self.longitude = location.longitude
    }
    
    var location: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

@Model
class Contact {
    
    var name: String
    var location: Coordinate2D?
    
    
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
