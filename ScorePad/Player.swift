//
//  Player.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

struct Player: Identifiable {
    let id = UUID()
    var name: String
    var score: Int = 0
    var sessionTotal: Int = 0
    var pendingSessionTotal: Int = 0
    var sessionHistory: [Int] = []
    var color: Color

    var lightColor: Color {
        color.mix(with: .white, by: 0.1)
    }

    var darkColor: Color {
        color.mix(with: .black, by: 0.1)
    }

    var lastSessionTotal: Int? {
        if pendingSessionTotal != 0 {
            return pendingSessionTotal
        }
        return sessionHistory.last
    }

    static let availableColors: [Color] = [
        Color(red: 0.25, green: 0.45, blue: 0.75),
        Color(red: 0.75, green: 0.28, blue: 0.28),
        Color(red: 0.22, green: 0.62, blue: 0.42),
        Color(red: 0.75, green: 0.55, blue: 0.18),
        Color(red: 0.52, green: 0.35, blue: 0.75),
        Color(red: 0.70, green: 0.32, blue: 0.55),
        Color(red: 0.18, green: 0.60, blue: 0.65),
        Color(red: 0.85, green: 0.45, blue: 0.15),
    ]
}
