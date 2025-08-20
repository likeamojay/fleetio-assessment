//
//  VehicleLocationView.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/20/25.
//

import SwiftUI
import MapKit

struct VehicleLocationView: View {
    let vehicle: Vehicle

    private let kUrlString = "https://secure.fleetio.com/api/vehicles/"

    @State private var mapRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var errorString = ""
    @State private var locationEntry: LocationEntry?
    @State private var isLoading = false

    var body: some View {
        Group {
            if !errorString.isEmpty {
                Text(errorString)
                    .foregroundStyle(.red)
                    .padding()
            } else if isLoading {
                Text("Loading Map...")
                    .padding()
            } else {
                Map(coordinateRegion: $mapRegion, annotationItems: pins) { pin in
                    MapMarker(coordinate: pin.coordinate)
                    // Or MapAnnotation(...) for a custom view
                }
                .frame(height: 300)
                .cornerRadius(12)
                .shadow(radius: 5)
            }
        }
        .onAppear {
            Task { await fetchLocationEntry() }
        }
        .onChange(of: locationEntry) { newValue in
            if let coord = newValue?.geolocation {
                mapRegion.center = CLLocationCoordinate2D(latitude: coord.latitude,
                                                          longitude: coord.longitude)
            }
        }
    }

    @MainActor
    private func fetchLocationEntry() async {
        guard let currentLocationEntryId = vehicle.currentLocationEntryId else {
            errorString = "No current location entry for this vehicle."
            return
        }

        let urlString = "\(kUrlString)\(vehicle.id)/location_entries/\(currentLocationEntryId)"
        guard let url = URL(string: urlString) else {
            errorString = "Bad URL."
            return
        }

        isLoading = true

        var request = URLRequest(url: url)
        request.setValue("Token \(Utils.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Utils.accountToken, forHTTPHeaderField: "Account-Token")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            isLoading = false

            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                errorString = "HTTP Error \((response as? HTTPURLResponse)?.statusCode ?? -1)"
                return
            }

            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let locationEntryResponse = try decoder.decode(LocationEntry.self, from: data)
            locationEntry = locationEntryResponse

            if let coord = locationEntry?.geolocation {
                mapRegion.center = CLLocationCoordinate2D(latitude: coord.latitude,
                                                          longitude: coord.longitude)
            } else {
                errorString = "No coordinates found for this vehicle."
            }
        } catch {
            isLoading = false
            errorString = "Failed to fetch location entries: \(error)"
        }
    }

    private struct MapPin: Identifiable {
        let id = UUID()
        let coordinate: CLLocationCoordinate2D
    }

    private var pins: [MapPin] {
        if let geo = locationEntry?.geolocation {
            return [MapPin(coordinate: CLLocationCoordinate2D(latitude: geo.latitude, longitude: geo.longitude))]
        }
        return []
    }

}

