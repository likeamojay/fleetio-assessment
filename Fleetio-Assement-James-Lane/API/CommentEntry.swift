//
//  CommentEntry.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import Foundation

struct CommentEntry: Decodable, Identifiable {
    let id: Int
    let createdAt: Date
    let updatedAt: Date
    let comment: String
}
