//
//  MeterCardView.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import SwiftUI

struct MeterCardView: View {
    let title: String
    let dateString: String?
    let valueString: String?
    let usagePerDayString: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8.0) {
            Text(title)
                .font(.title3)
                .bold()

            if let dateString {
                Text("Last Updated Date: \(dateString)")
            }
            if let valueString {
                Text("Current Value: \(valueString)")
            }
            if let usagePerDayString {
                Text("Usage Per Day: \(usagePerDayString)")
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(
            Rectangle()
                .foregroundStyle(.fill)
                .cornerRadius(8.0)
        )
    }
}


