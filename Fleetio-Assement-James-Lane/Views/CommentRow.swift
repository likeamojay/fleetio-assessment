//
//  CommentRow.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import SwiftUI

struct CommentRow: View {

    var entry: CommentEntry

    var body: some View {
        Text(entry.comment)
            .multilineTextAlignment(.center)
    }
}
