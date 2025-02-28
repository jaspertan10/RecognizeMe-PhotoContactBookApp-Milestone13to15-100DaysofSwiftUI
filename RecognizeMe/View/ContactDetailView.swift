//
//  ContactDetailView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/16/25.
//

import SwiftUI
import SwiftData
import MapKit

struct ContactDetailView: View {
    
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    
    let contact: Contact
    private var startPosition: MapCameraPosition?
    
    init(contact: Contact) {
        self.contact = contact
        
        if let coordinate2D = contact.location {
            //Default to San Jose
            let center = coordinate2D.location
    
            self.startPosition = MapCameraPosition.region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        }
    }
    
//    init(location: Binding<Coordinate2D?>, locationMet: Binding<Coordinate2D?>) {
//        self._location = location
//        
//        //Default to San Jose
//        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.3387, longitude: -121.8853)
//        let center = location.wrappedValue?.location ?? defaultCoordinate
//        
//        self.startPosition = MapCameraPosition.region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
//        
//        self._locationMet = locationMet
//    }
    
    
    var body: some View {
        ScrollView {
            if let image = contact.getImage() {
                image
                    .resizable()
                    .scaledToFit()
            }
            
            Text(contact.name)
            
            if let contactMetLocation = contact.location {
                if let startPosition = startPosition {
                    Map(initialPosition: startPosition) {
                        Marker("Location met", coordinate: contactMetLocation.location)
                    }
                    .frame(height: 400)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ContactDetailView(contact: Contact(name: <#T##String#>, photo: nil))
//}
