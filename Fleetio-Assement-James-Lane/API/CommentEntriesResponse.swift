//
//  CommentEntriesResponse.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import Foundation

struct CommentEntriesResponse: Decodable {

    let startCursor: String?
    let nextCursor: String?
    let perPage: Int
    let records: [CommentEntry]

}
