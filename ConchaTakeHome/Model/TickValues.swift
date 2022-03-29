//
//  TickValues.swift
//  ConchaTakeHome
//
//  Created by Amr Al-Refae on 2022-03-28.
//

import Foundation

struct TickValues: Codable {
    let ticks: [Double]?
    let sessionID: Int
    let stepCount: Int?
    let complete: String?

    enum CodingKeys: String, CodingKey {
        case ticks
        case sessionID = "session_id"
        case stepCount = "step_count"
        case complete
    }
}
