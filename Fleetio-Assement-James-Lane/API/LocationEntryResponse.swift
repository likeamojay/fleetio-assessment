//
//  LocationEntryResponse.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import Foundation

struct LocationEntryResponse: Decodable {

    let startCursor: String?
    let nextCursor: String?
    let perPage: Int
    let records: [LocationEntry]

}
