//
//  GameViewModel.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

@Observable
class GameViewModel {
    var players: [Player] = []
    var colorSchemePreference: ColorSchemePreference = .automatic

    init(playerCount: Int = 2) {
        setPlayerCount(playerCount)
    }

    func setPlayerCount(_ count: Int) {
        let clampedCount = min(max(count, 1), 8)

        if clampedCount > players.count {
            for i in players.count..<clampedCount {
                let color = Player.availableColors[i % Player.availableColors.count]
                players.append(Player(name: "Player \(i + 1)", color: color))
            }
        } else if clampedCount < players.count {
            players.removeLast(players.count - clampedCount)
        }
    }

    func addScore(_ points: Int, to playerID: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        players[index].score += points
        players[index].sessionTotal += points
        players[index].pendingSessionTotal = players[index].sessionTotal
    }

    func undoLastEntry(_ points: Int, for playerID: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        players[index].score -= points
        players[index].sessionTotal -= points
        players[index].pendingSessionTotal = players[index].sessionTotal
    }

    func closeSession(for playerID: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        guard players[index].sessionTotal != 0 else { return }
        players[index].sessionHistory.append(players[index].sessionTotal)
        players[index].sessionTotal = 0
        players[index].pendingSessionTotal = 0
    }

    func undoLastSession(for playerID: Player.ID) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        guard let last = players[index].sessionHistory.last else { return }
        players[index].score -= last
        players[index].sessionHistory.removeLast()
    }

    func resetGame() {
        for index in players.indices {
            players[index].score = 0
            players[index].sessionTotal = 0
            players[index].sessionHistory = []
            players[index].pendingSessionTotal = 0
        }
    }

    func renamePlayer(_ playerID: Player.ID, to name: String) {
        guard let index = players.firstIndex(where: { $0.id == playerID }) else { return }
        let trimmed = name.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return }
        players[index].name = trimmed
    }
    
    func resetToDefaults() {
        players = []
        colorSchemePreference = .automatic
        setPlayerCount(2)
    }
}
