//
//  AnalyticsService.swift
//  Tracker
//
//  Created by Максим Лозебной on 01.03.2026.
//
import AppMetricaCore

struct AnalyticsService {
    static let apiKey: String = "e763e4e0-94ea-4aa8-a8c4-1adf09ad6cc0"
    
    static let shared = AnalyticsService()
    
    static func setupAppMetrica() {
        if let configuration = AppMetricaConfiguration(apiKey: apiKey) {
            AppMetrica.activate(with: configuration)
        }
    }
    
    func report(event: String, params: [AnyHashable: Any]) {
        AppMetrica.reportEvent(name: event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
