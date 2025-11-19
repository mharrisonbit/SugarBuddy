//
//  GlucloseParser.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/15/25.
//

import Foundation

struct GlucoseRecord: Identifiable, Codable {
    let id: String
    let value: Double
    let unit: String
    
    let deviceModel: String?
    let osVersion: String?
    let deviceName: String?
    
    let syncIdentifier: String?
    let syncVersion: Int?
    
    let timezone: String?
    let status: String?
    let trendArrow: String?
    let trendRate: Double?
    let transmitterTime: Int?
    
    let startDate: Date
    let endDate: Date
    
    let rawMetadata: [String: AnyCodable]?
}
