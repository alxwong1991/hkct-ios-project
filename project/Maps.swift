//
//  Maps.swift
//  project
//
//  Created by Alex MAC on 12/4/2023.
//

import SwiftUI
import MapKit

struct IdentifiablePlace: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

struct Maps: View {
    
    private var lat: Double
    private var lon: Double
    
    @State private var region: MKCoordinateRegion
    
    init(lat: Double, lon: Double, region: MKCoordinateRegion) {
        self.lat = lat
        self.lon = lon
        self.region = region
    }
    
    var body: some View {
        let place: IdentifiablePlace = IdentifiablePlace(lat: lat, long: lon)
        GeometryReader { geo in
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [place]){
                place in
                MapMarker(coordinate: place.location,
                          tint: Color.purple)
            }
            .frame(width: geo.size.width, height: geo.size.height-50)
            .padding(.top, 50)
        }
    }
}
