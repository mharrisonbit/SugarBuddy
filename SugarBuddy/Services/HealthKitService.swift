import Foundation
import SwiftUI
import HealthKit

@Observable
class HealthKitService {

    let healthStore = HKHealthStore()
    var readings: [GlucoseRecord] = []
    var currentReading = "0.0"
    var isLoading: Bool = false

    func getReadings(range:String) async {
        isLoading = true
        guard HKHealthStore.isHealthDataAvailable() else {
            isLoading = false
            return
        }
        
        // Correct types
        guard let glucoseType = HKQuantityType.quantityType(forIdentifier: .bloodGlucose) else {
            isLoading = false
            return
        }
        
        let readTypes: Set = [glucoseType]
        
        // Request permissions
        do {
            try await healthStore.requestAuthorization(toShare: [], read: readTypes)
        } catch {
            print("Authorization failed:", error)
            isLoading = false
            return
        }
        
        // Check authorization
        let status = healthStore.authorizationStatus(for: glucoseType)
        guard status == .sharingAuthorized else {
            print("Not authorized for glucose data")
            isLoading = false
            return
        }
        
        // Return awaitable query
        let data = await fetchReadings(glucoseType: glucoseType, range:range)
        
        readings = data.map { sample in
            let md = sample.metadata ?? [:]
            
            return GlucoseRecord(
                id: sample.uuid.uuidString,
                value: sample.quantity.doubleValue(for: HKUnit(from: "mg/dL")),
                unit: "mg/dL",
                
                deviceModel: sample.device?.model,
                osVersion: sample.device?.softwareVersion,
                deviceName: md["HKDeviceName"] as? String,
                
                syncIdentifier: md["HKMetadataKeySyncIdentifier"] as? String,
                syncVersion: md["HKMetadataKeySyncVersion"] as? Int,
                
                timezone: md["HKTimeZone"] as? String,
                status: md["Status"] as? String,
                trendArrow: md["Trend Arrow"] as? String,
                trendRate: Double(md["Trend Rate"] as? String ?? ""),
                transmitterTime: md["Transmitter Time"] as? Int,
                
                startDate: sample.startDate,
                endDate: sample.endDate,
                
                rawMetadata: md.mapValues { AnyCodable($0) }
            )
        }
        .unique(on: { $0.id })

        currentReading = "Current Reading " + String(format: "%.0f", readings.first?.value ?? "0.0") + " mg/dL at " + dateFormatter(dateToFormat: readings.first?.startDate ?? Date.now, formatString: "h:mm:ss a")

        isLoading = false
    }

    private func fetchReadings(glucoseType: HKQuantityType, range:String) async -> [HKQuantitySample] {
        await withCheckedContinuation { continuation in
            
            var timeFrame = 0
            switch range {
                case "30 Days":
                    timeFrame = -30
                    break
                case "60 Days":
                    timeFrame = -60
                    break
                case "90 Days":
                    timeFrame = -90
                    break
                default:
                timeFrame = -1
                    break
            }
            
            let endDate = Date()
            let startDate = Calendar.current.date(byAdding: .day, value: timeFrame, to: endDate)!

            let predicate = HKQuery.predicateForSamples(
                withStart: startDate,
                end: endDate,
                options: .strictStartDate
            )

            let sort = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)

            let query = HKSampleQuery(
                sampleType: glucoseType,
                predicate: predicate,
                limit: HKObjectQueryNoLimit,
                sortDescriptors: [sort]
            ) { _, samples, error in

                guard let samples = samples as? [HKQuantitySample], error == nil else {
                    continuation.resume(returning: [])
                    return
                }

                continuation.resume(returning: samples)
            }

            healthStore.execute(query)
        }
    }
}
