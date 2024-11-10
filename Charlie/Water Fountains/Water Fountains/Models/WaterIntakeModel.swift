//
//  daily_hydration_data.swift
//  Water Fountains
//
//  Created by Jay Zhao on 11/8/24.
//

import Foundation

struct WaterIntake: Identifiable {
    let id = UUID()
    var amount: Double // in milliliters
    var date: Date
}



