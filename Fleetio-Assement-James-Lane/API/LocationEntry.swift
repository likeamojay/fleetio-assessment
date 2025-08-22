//
//  LocationEntry.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import Foundation

struct LocationEntry: Decodable, Equatable {
    struct geolocation: Decodable, Equatable {
        let latitude: Double
        let longitude: Double
    }
    let geolocation: geolocation
}
