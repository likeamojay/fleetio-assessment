//
//  VehicleListViewModel.swift
//  iOS Platform Assessment
//
//  Created by James Lane on 7//25.
//

import Foundation
import Combine

@MainActor
class VehicleListViewModel: ObservableObject {

    @Published var isInitialLoading = false
    @Published var errorString = ""
    @Published var searchText: String = ""
    @Published private(set) var vehicles: [Vehicle] = []
    @Published var isFetchingNextPage = false

    private let kUrlString = "https://secure.fleetio.com/api/vehicles"
    private var startCursor: String?
    private var nextCursor: String?
    private var cancellables = Set<AnyCancellable>()
    private var perPage = 10

    var hasNextPage: Bool {
        nextCursor != nil
    }

    init() {
        $searchText
            .first(where: { !$0.isEmpty })
            .sink { [weak self] term in
                guard let self else { return }
                Task {
                    await self.fetchAllVehicles()
                }
            }
            .store(in: &cancellables)
    }

    func fetchAllVehicles() async {
        if isFetchingNextPage {
            print("ignore becuase we're busy")
            return
        }
        while hasNextPage {
            await fetchVehicles()
        }
    }

    func fetchVehicles() async {
        guard !isFetchingNextPage else { return }
        if nextCursor == nil && startCursor != nil {
            return
        }

        isFetchingNextPage = nextCursor != nil
        if startCursor == nil {
            isInitialLoading = true
        }

        defer {
            isInitialLoading = false
            isFetchingNextPage = false
        }

        guard var urlComponents = URLComponents(string: kUrlString) else { return }

        var queryItems = [URLQueryItem(name: "per_page", value: "\(self.perPage)")]
        if let nextCursor {
            queryItems.append(URLQueryItem(name: "start_cursor", value: nextCursor))
        }

        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else {
            errorString = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.setValue("Token \(Utils.apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(Utils.accountToken, forHTTPHeaderField: "Account-Token")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                errorString = "HTTP Error \(String(describing: (response as? HTTPURLResponse)?.statusCode))"
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            let vehiclesResponse = try decoder.decode(VehiclesResponse.self, from: data)
            vehicles += vehiclesResponse.records

            self.startCursor = vehiclesResponse.startCursor
            self.nextCursor = vehiclesResponse.nextCursor
        } catch {
            errorString = "Failed to fetch vehicles: \(error.localizedDescription)"
            self.nextCursor = nil
        }
    }

    func shouldLoadNextPage(currentItem: Vehicle) -> Bool {
        guard !isFetchingNextPage else { return false }
        guard hasNextPage else { return false }
        return currentItem.id == filteredVehicles.last?.id
    }

    var filteredVehicles: [Vehicle] {
        guard !searchText.isEmpty else { return vehicles }

        let terms = searchText.lowercased().split(separator: " ")
        return vehicles.filter { vehicle in
            terms.allSatisfy { term in
                vehicle.name.lowercased().contains(term) ||
                (vehicle.makeString).lowercased().contains(term) ||
                vehicle.modelString.lowercased().contains(term) ||
                vehicle.yearString.contains(term)
            }
        }
    }

    var isFirstPage: Bool {
        return self.vehicles.count == self.perPage
    }
}


