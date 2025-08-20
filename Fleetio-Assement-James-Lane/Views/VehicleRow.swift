//
//  VehicleRow.swift
//  iOS Platform Assessment
//
//  Created by James Lane on 7/18/25.
//

import SwiftUI

struct VehicleRow: View {

    let vehicle: Vehicle

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let urlString = self.vehicle.defaultImageUrlSmall, let url = URL(string:urlString) {
                    AsyncImage(url: url) { image in
                            image.resizable()
                            image.cornerRadius(8.0)
                        } placeholder: {
                            Image(systemName: "car")
                                .imageScale(.large)
                                .frame(width: 50, height: 50)
                        }.frame(width: 50, height: 50)
                } else {
                    Image(systemName: "car")
                        .imageScale(.large)
                        .frame(width: 50, height: 50)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(vehicle.name)
                    .font(.headline)
                    .foregroundStyle(.black)

                HStack {
                    Text(vehicle.yearString)
                    Text(vehicle.makeString)
                    Text(vehicle.modelString)
                }
                .font(.subheadline)

                HStack {
                    Circle()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(vehicle.vehicleStatusName == "Active" ? .green : .red)
                    Text(vehicle.vehicleStatusName)
                        .font(.caption)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
