//
//  LocationViewController.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 13/10/22.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    private let locationViewModel: LocationViewModel = LocationViewModel()
    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var locationTitle: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    private var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.locationViewModel.requestPermition()
        self.playPauseTrackButtonImageHandler()
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { time in
            self.mapView.centerToLocation(withMKCoordinateRegion: self.locationViewModel.region)
            self.mapView.setPin(withLocationList: self.locationViewModel.pinList)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.timer.invalidate()
        self.locationViewModel.disableLocationTrack()
    }
    
    @IBAction func trackButton(_ sender: UIButton) {
        self.locationViewModel.startStopTrackingLocation()
        self.playPauseLocationTitleHandler()
        self.playPauseTrackButtonImageHandler()
    }
    
    @IBAction func goToSettings(_ sender: UIButton) -> Void {
        let bundleId = "dev.zoominitcode.background.features.example"
        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=Location/\(bundleId)")!
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

extension LocationViewController {
    func playPauseLocationTitleHandler() -> Void {
        let name: String = self.locationViewModel.isLocationTrakingEnabled ? "Stop" : "Start"
        self.locationTitle.text = name
    }
    
    func playPauseTrackButtonImageHandler() -> Void {
        let imageName: String = self.locationViewModel.isLocationTrakingEnabled ? "stop" : "location"
        self.trackButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}

private extension MKMapView {
      func centerToLocation(
        withMKCoordinateRegion mKCoordinateRegion: MKCoordinateRegion
      ) -> Void {
        setRegion(mKCoordinateRegion, animated: true)
      }
    
    func setPin(withLocationList locationList: Array<PinLocationType>) -> Void {
        let pinList: Array<MKPlacemark> = locationList.map { location in
            let pin = MKPlacemark(coordinate: location.coordinate)
            return pin
        }
        addAnnotations(pinList)
    }
}
