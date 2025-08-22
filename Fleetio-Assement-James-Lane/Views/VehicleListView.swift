//
//  VehicleListView.swift
//  iOS Platform Assessment
//
//  Created by James Lane on 7/13/25.
//

import Foundation
import SwiftUI

struct VehicleListView: View {

    @StateObject private var viewModel = VehicleListViewModel()

    var body: some View {
        Group {
            if viewModel.isInitialLoading {
                ProgressView("Loading Vehicles...")
                    .progressViewStyle(CircularProgressViewStyle())
                    .scaleEffect(1.5)
            } else if !viewModel.errorString.isEmpty {
                Text(viewModel.errorString)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
            } else {
                VStack {
                    List {
                        ForEach(viewModel.filteredVehicles) { vehicle in
                            NavigationLink(destination: VehicleView(vehicle: vehicle)) {
                                VehicleRow(vehicle: vehicle)
                            }
                            .onAppear {
                                if viewModel.shouldLoadNextPage(currentItem: vehicle) {
                                    Task {
                                        await viewModel.fetchVehicles()
                                    }
                                }
                            }
                        }
                    }
                    if !viewModel.isInitialLoading && viewModel.isFetchingNextPage {
                        ProgressView().progressViewStyle(.circular)
                        Spacer()
                    }
                }
                .searchable(text: $viewModel.searchText)
                .navigationTitle("Vehicles")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .onAppear {
            if viewModel.vehicles.isEmpty {
                Task {
                    await viewModel.fetchVehicles()
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        VehicleListView()
    }
}
