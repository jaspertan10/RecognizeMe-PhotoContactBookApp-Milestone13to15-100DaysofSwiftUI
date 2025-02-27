//
//  MapView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/21/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Environment(\.dismiss) var dismiss
    
    @Binding var location: Coordinate2D?
    
    private var startPosition: MapCameraPosition
    
    @Binding var locationMet: Coordinate2D?
    
    init(location: Binding<Coordinate2D?>, locationMet: Binding<Coordinate2D?>) {
        self._location = location
        
        //Default to San Jose
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.3387, longitude: -121.8853)
        let center = location.wrappedValue?.location ?? defaultCoordinate
        
        self.startPosition = MapCameraPosition.region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
        
        self._locationMet = locationMet
    }
    
    
    var body: some View {
        NavigationStack {
            MapReader { proxy in
                Map(initialPosition: startPosition) {
                    
                    if let locationMet = locationMet {
                        Marker("Location met", coordinate: locationMet.location)
                    }
                    
                }
                .onTapGesture { position in
                    if let coordinate = proxy.convert(position, from: .local) {
                        locationMet = Coordinate2D(coordinate)
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var previewLocation: Coordinate2D? = Coordinate2D(CLLocationCoordinate2D(latitude: 37.3387, longitude: -121.8853))
    @Previewable @State var locationMet: Coordinate2D?
    MapView(location: $previewLocation, locationMet: $locationMet)
}
