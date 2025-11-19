//
//  GlobalUtilities.swift
//  SugarBuddy
//
//  Created by Michael Harrison on 11/16/25.
//

import Foundation
import SwiftUI

// MARK: - Unique Utility
extension Array {
    func unique<T: Hashable>(on key: (Element) -> T) -> [Element] {
        var seen = Set<T>()
        return self.filter { element in
            let k = key(element)
            if seen.contains(k) { return false }
            seen.insert(k)
            return true
        }
    }
}

// MARK: - AnyCodable
struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) { self.value = value }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let int = try? container.decode(Int.self)      { value = int }
        else if let dbl = try? container.decode(Double.self) { value = dbl }
        else if let bool = try? container.decode(Bool.self)  { value = bool }
        else if let str = try? container.decode(String.self) { value = str }
        else { value = "" }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch value {
        case let v as Int:    try container.encode(v)
        case let v as Double: try container.encode(v)
        case let v as Bool:   try container.encode(v)
        case let v as String: try container.encode(v)
        default:              try container.encodeNil()
        }
    }
}

// MARK: - A1C Status Enum
enum A1CStatus: String {
    case normal = "Normal"
    case prediabetic = "Pre-Diabetic"
    case diabetic = "Diabetic"

    var color: Color {
        switch self {
        case .normal: return .green
        case .prediabetic: return .yellow
        case .diabetic: return .red
        }
    }

    var icon: String {
        switch self {
        case .normal: return "checkmark.circle.fill"
        case .prediabetic: return "exclamationmark.circle.fill"
        case .diabetic: return "xmark.octagon.fill"
        }
    }
}

// MARK: - Glucose Extensions
extension Array where Element == GlucoseRecord {
    
    /// Estimated A1C for the readings
    func estimatedA1C() -> Double? {
        guard !self.isEmpty else { return nil }
        let avgGlucose = self.map { $0.value }.reduce(0, +) / Double(self.count)
        return (avgGlucose + 46.7) / 28.7
    }
    
    /// Enum-based classification
    func a1cClassification() -> A1CStatus {
        guard let a1c = self.estimatedA1C() else { return .normal }

        switch a1c {
        case ..<5.7:     return .normal
        case 5.7..<6.5:  return .prediabetic
        default:         return .diabetic
        }
    }

    /// Convenience for color
    func a1cColor() -> Color {
        a1cClassification().color
    }

    /// Convenience for icon
    func a1cIcon() -> String {
        a1cClassification().icon
    }
}


// MARK: - 7 Day Average Utility
func sevenDayAverage(from readings: [GlucoseRecord]) -> Double? {
    let now = Date()
    guard let weekAgo = Calendar.current.date(byAdding: .day, value: -7, to: now) else { return nil }

    let filtered = readings.filter {
        $0.startDate >= weekAgo && $0.startDate <= now
    }

    guard !filtered.isEmpty else { return nil }

    let avg = filtered.reduce(0.0) { $0 + $1.value } / Double(filtered.count)
    return avg
}


extension Array where Element == GlucoseRecord {
    func trendChange() -> Double {
        let sorted = self.sorted { $0.startDate < $1.startDate }
        guard sorted.count > 10 else { return 0 }
        
        let first = Array(sorted.prefix(10)).estimatedA1C() ?? 0
        let last = Array(sorted.suffix(10)).estimatedA1C() ?? 0
        
        return last - first
    }
}

// MARK: - Time In Range (Last 24 Hours)
struct TimeInRangeSummary {
    let low: Int
    let inRange: Int
    let high: Int
    let total: Int

    var lowPercent: Double { total == 0 ? 0 : Double(low) / Double(total) }
    var inRangePercent: Double { total == 0 ? 0 : Double(inRange) / Double(total) }
    var highPercent: Double { total == 0 ? 0 : Double(high) / Double(total) }
}

extension Array where Element == GlucoseRecord {
    func timeInRangeLast24Hours(
        lowThreshold: Double = 70,
        highThreshold: Double = 180
    ) -> TimeInRangeSummary {
        
        let now = Date()
        let last24 = Calendar.current.date(byAdding: .hour, value: -24, to: now)!

        let filtered = self.filter { $0.startDate >= last24 }

        var low = 0
        var inRange = 0
        var high = 0

        for r in filtered {
            if r.value < lowThreshold {
                low += 1
            } else if r.value > highThreshold {
                high += 1
            } else {
                inRange += 1
            }
        }

        return TimeInRangeSummary(low: low, inRange: inRange, high: high, total: filtered.count)
    }
}

extension Array where Element == GlucoseRecord {
    func lastHours(_ hours: Int) -> [GlucoseRecord] {
        let cutoff = Calendar.current.date(byAdding: .hour, value: -hours, to: Date())!
        return self.filter { $0.startDate >= cutoff }
            .sorted(by: { $0.startDate < $1.startDate })
    }
}

extension Array where Element == Double {
    var average: Double? {
        guard !self.isEmpty else { return nil }
        return self.reduce(0, +) / Double(self.count)
    }
}

extension Array where Element == GlucoseRecord {
    private struct DayHour: Hashable {
        let day: Date
        let hour: Int
    }
    
    func hourlyAverages() -> [HourlyAverage] {
        let grouped = Dictionary(grouping: self) { record -> DayHour in
            let day = Calendar.current.startOfDay(for: record.startDate)
            let hour = Calendar.current.component(.hour, from: record.startDate)
            return DayHour(day: day, hour: hour)
        }

        return grouped.map { key, records in
            let avg = records.map { $0.value }.reduce(0, +) / Double(records.count)
            return HourlyAverage(day: key.day, hour: key.hour, average: avg)
        }
        .sorted { $0.day < $1.day || ($0.day == $1.day && $0.hour < $1.hour) }
    }
}

struct HourlyAverage {
    var id: String? { "\(day.timeIntervalSinceReferenceDate)-\(hour)" }
    let day: Date
    let hour: Int
    let average: Double
}
