//
//  PlayerScoreCard.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

struct PlayerScoreCard: View {
    let player: Player
    let onTap: () -> Void
    let onUndoLastSession: () -> Void

    var body: some View {
        Button(action: onTap) {
            ZStack {
                RadialGradient(
                    colors: [player.lightColor, player.darkColor],
                    center: .center,
                    startRadius: 0,
                    endRadius: 120
                )

                Text("\(player.score)")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.white)

                if let lastSession = player.lastSessionTotal {
                    VStack {
                        Spacer()
                        Button(action: onUndoLastSession) {
                            Label(
                                "Undo +\(lastSession)",
                                systemImage: "arrow.uturn.backward"
                            )
                            .font(.caption)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.white.opacity(0.3))
                        .foregroundStyle(.white)
                        .padding(.bottom, 10)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    PlayerScoreCard(
        player: Player(name: "Player 1", score: 20, color: Player.availableColors[0]),
        onTap: {},
        onUndoLastSession: {}
    )
    .frame(width: 160, height: 160)
    .padding()
}
