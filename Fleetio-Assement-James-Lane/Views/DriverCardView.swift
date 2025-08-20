//
//  DriverCardView.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import SwiftUI

struct DriverCardView: View {

    var driver: Driver

    var body: some View {
        HStack {
            if let urlString = driver.defaultImageUrl, let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()   // or .scaledToFit(), depending on behavior you want
                        .frame(width: 50, height: 50)
                        .cornerRadius(8.0)
                        .clipped()        // crop overflow if using .scaledToFill
                } placeholder: {
                    Image(systemName: "person.fill.questionmark")
                        .imageScale(.large)
                        .frame(width: 50, height: 50)
                }
                .frame(width: 50, height: 50)
                .padding(8)
            }

            VStack(alignment: .leading, spacing: 8.0) {
                Text("Driver Info")
                    .font(.title3)
                    .bold()
                if let name = driver.name {
                    Text("Name: \(name)")
                }
                if let email = driver.email {
                    Text("Email: \(email)")
                }
                if let employee = driver.employee {
                    Text("Employee: \(employee ? "Y" : "N")")
                }
            }
            .padding(.leading)
            .padding(.top)
            .padding(.bottom)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            Rectangle()
                .foregroundStyle(.fill)
                .cornerRadius(8.0)
        )
    }
}
