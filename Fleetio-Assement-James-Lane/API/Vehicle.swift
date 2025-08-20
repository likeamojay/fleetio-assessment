//
//  Vehicle.swift
//  iOS Platform Assessment
//
//  Created by James Lane on 8/16/25.
//

import Foundation

struct Vehicle: Identifiable, Decodable {
    let id: Int
    let currentLocationEntryId: Int?
    let defaultImageUrlSmall: String?
    let driver: Driver?
    let name: String
    private let model: String?
    private let year: Int?
    private let make: String?
    let location: String?
    let licensePlate: String?
    private let primaryMeterDate: String?
    private let primaryMeterValue: String?
    private let primaryMeterUnit: String?
    private let primaryMeterUsagePerDay: String?
    private let secondaryMeterDate: String?
    private let secondaryMeterValue: String?
    private let secondaryMeterUnit: String?
    private let secondaryMeterUsagePerDay: String?
    let vehicleStatusName: String
    let vin: String?
}

extension Vehicle {

    // MARK: - Public API

    var locationString: String {
        return self.location ?? "Location"
    }

    var makeString: String {
        return self.make ?? "Make"
    }

    var modelString: String {
        return self.model ?? "Model"
    }

    var primaryMeterDateString: String? {
        guard let dateString = self.primaryMeterDate else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        return date?.formatted(date: .abbreviated, time: .omitted) ?? nil
    }

    var primaryMeterValueString: String? {
        return self.formattedMeterString(value: self.primaryMeterValue, unit: self.primaryMeterUnit)
    }

    var primaryMeterUsagePerDayString: String? {
        return self.formattedMeterString(value: self.primaryMeterUsagePerDay, unit: self.primaryMeterUnit)
    }

    var secondaryMeterDateString: String? {
        guard let dateString = self.secondaryMeterDate else { return nil }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.date(from: dateString)
        return date?.formatted(date: .abbreviated, time: .omitted) ?? nil
    }

    var secondaryMeterValueString: String? {
        return self.formattedMeterString(value: self.secondaryMeterValue, unit: self.secondaryMeterUnit)
    }

    var secondaryMeterUsagePerDayString: String? {
        return self.formattedMeterString(value: self.secondaryMeterUsagePerDay, unit: self.secondaryMeterUnit)
    }

    var yearString: String {
        return "\(year ?? 2025)".replacingOccurrences(of: ",", with: "")
    }

    // MARK: - Helpers

    private func formattedMeterString(value: String?, unit: String?) -> String? {
        guard let value else { return nil }
        var str = value
        let isPlural = (Double(value) ?? 0) > 1.0
        switch unit {
        case "hr":
            str += " hour\(isPlural ? "s" : "")"
        case "km":
            str += " kilometer\(isPlural ? "s" : "")"
        case "mi":
            str += " mile\(isPlural ? "s" : "")"
        default:
            break
        }
        return str
    }
}
