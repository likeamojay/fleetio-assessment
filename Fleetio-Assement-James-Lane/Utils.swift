//
//  Utils.swift
//  Fleetio-Assement-James-Lane
//
//  Created by James Lane on 8/19/25.
//

import Foundation

class Utils {

    // MARK: - Public APIs

    static var apiKey: String {
        guard let apiKey = credentials["apiKey"] as? String, !apiKey.isEmpty else {
            fatalError("Error loading API Key")
        }
        return apiKey
    }

    static var accountToken: String {
        guard let accountToken = credentials["accountToken"] as? String, !accountToken.isEmpty else {
            fatalError("Error loading account token")
        }
        return accountToken
    }

    // MARK: - Debugging

    static func printJSON(_ data: Data) {
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
            let prettyData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
            if let prettyString = String(data: prettyData, encoding: .utf8) {
                print("Incoming JSON:\n\(prettyString)")
            }
        } catch {
            print("Failed to print JSON: \(error.localizedDescription)")
        }
    }

    // MARK: - Helpers

    private static var credentials: NSDictionary {
        guard let path = Bundle.main.path(forResource: "Credentials", ofType: "plist"), let credentials = NSDictionary(contentsOfFile: path) else {
            fatalError("Error loading credentials")
        }
        return credentials
    }
}


