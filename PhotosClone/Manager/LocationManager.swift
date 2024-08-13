//
//  LocationManager.swift
//  PhotosClone
//
//  Created by Lena on 2024/8/13.
//

import CoreLocation

class LocationManager {
    static let shared = LocationManager()
    
    private let geocoder = CLGeocoder()
    
    private init() { }
    
    func reverseGeocode(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async -> String {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: latitude, longitude: longitude)
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            guard let placemark = placemarks.first, let address = placemark.name else {
                return "Unknown"
            }
            return address
        } catch {
            return "Error: \(error.localizedDescription)"
        }
    }
}
