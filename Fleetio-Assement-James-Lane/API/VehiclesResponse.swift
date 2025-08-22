//
//  VehiclesResponse.swift
//  iOS Platform Assessment
//
//  Created by James Lane on 8/16/25.
//

import Foundation

struct VehiclesResponse: Decodable {
    let startCursor: String
    let nextCursor: String?
    let perPage: Int
    let filteredBy: [String]
    let records: [Vehicle]
}
