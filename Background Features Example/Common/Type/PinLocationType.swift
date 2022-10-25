//
//  PinLocationType.swift
//  Background Features Example
//
//  Created by Paulo Antonelli on 14/10/22.
//

import Foundation
import CoreLocation

struct PinLocationType: Identifiable {
    let id: String = UUID().uuidString
    var coordinate: CLLocationCoordinate2D
}
