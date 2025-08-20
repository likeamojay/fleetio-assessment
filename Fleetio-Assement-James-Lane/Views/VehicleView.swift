import Foundation
import SwiftUI

struct VehicleView: View {

    @State var vehicle: Vehicle

    var body: some View {
        ScrollView {
            VStack {
                Text("Status: \(vehicle.vehicleStatusName)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .bold()
                Divider()
                if let licensePlate = vehicle.licensePlate {
                    Text("License Plate #: \(licensePlate)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    Divider()
                }
                if let vin = vehicle.vin {
                    Text("VIN: \(vin)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .bold()
                    Divider()
                }
                if let driver = vehicle.driver {
                    DriverCardView(driver: driver)
                }
                MeterCardView(
                    title: "Primary Meter",
                    dateString: vehicle.primaryMeterDateString,
                    valueString: vehicle.primaryMeterValueString,
                    usagePerDayString: vehicle.primaryMeterUsagePerDayString
                )

                MeterCardView(
                    title: "Secondary Meter",
                    dateString: vehicle.secondaryMeterDateString,
                    valueString: vehicle.secondaryMeterValueString,
                    usagePerDayString: vehicle.secondaryMeterUsagePerDayString
                )
                Divider()
                if vehicle.currentLocationEntryId != nil {
                    Text("Current Location")
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    VehicleLocationView(vehicle: vehicle)
                }
                Text("Comments")
                    .font(.title)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                CommentsListView()
                Spacer()
            }
            .padding()
            .navigationTitle(vehicle.name)
        }
    }
}
