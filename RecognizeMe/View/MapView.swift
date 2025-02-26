//
//  MapView.swift
//  RecognizeMe
//
//  Created by Jasper Tan on 2/21/25.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @Binding var location: Coordinate2D?
    
    private var startPosition: MapCameraPosition
    
    init(location: Binding<Coordinate2D?>) {
        self._location = location
        
        //Default to San Jose
        let defaultCoordinate = CLLocationCoordinate2D(latitude: 37.3387, longitude: -121.8853)
        let center = location.wrappedValue?.location ?? defaultCoordinate
        
        self.startPosition = MapCameraPosition.region(MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)))
    }
    
    
    var body: some View {
        Map(initialPosition: startPosition)
    }
}

#Preview {
    @Previewable @State var previewLocation: Coordinate2D? = Coordinate2D(CLLocationCoordinate2D(latitude: 37.3387, longitude: -121.8853))
    MapView(location: $previewLocation)
}
