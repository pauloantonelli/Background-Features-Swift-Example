//
//  LocationModel.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 14/10/22.
//

import Combine
import CoreLocation
import MapKit

class LocationViewModel: NSObject, CLLocationManagerDelegate {
    var isLocationTrakingEnabled: Bool = false
    var location: CLLocation = CLLocation(latitude: -23.609496, longitude: -46.757034)
    var region: MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: -23.609496, longitude: -46.757034), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
    )
    var pinList: Array<PinLocationType> = []
    let locationManager: CLLocationManager
    
    override init() {
        self.locationManager = CLLocationManager()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.allowsBackgroundLocationUpdates = true
        super.init()
        self.locationManager.delegate = self
    }
    
    func startStopTrackingLocation() -> Void {
        self.isLocationTrakingEnabled.toggle()
        if self.isLocationTrakingEnabled {
            self.enableLocationTrack()
        } else {
            self.disableLocationTrack()
        }
    }
    
    fileprivate func enableLocationTrack() -> Void {
        self.locationManager.startUpdatingLocation()
    }
    
    func disableLocationTrack() -> Void {
        self.locationManager.stopUpdatingLocation()
    }
    
    func requestPermition() -> Void {
        self.locationManager.requestAlwaysAuthorization()
    }
}

extension LocationViewModel {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            print("Failure on get first location")
            return
        }
        print("currentLocation: \(currentLocation)")
        self.location = currentLocation
        self.appendPint(withLocation: currentLocation)
        self.updateRegion(withLocation: currentLocation)
    }
    
    func appendPint(withLocation location: CLLocation) -> Void {
        self.pinList.append(PinLocationType(coordinate: location.coordinate))
    }
    
    func updateRegion(withLocation location: CLLocation) -> Void {
        self.region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.0015, longitudeDelta: 0.0015))
    }
}
