//
//  PlayerScorePreview.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

struct PlayerScorePreview: View {
    let player: Player
    let sessionTotal: Int

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(
                    RadialGradient(
                        colors: [player.lightColor, player.darkColor],
                        center: .center,
                        startRadius: 0,
                        endRadius: 60
                    )
                )

            Text("\(sessionTotal)")
                .font(.system(size: 48, weight: .bold))
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    PlayerScorePreview(
        player: Player(name: "Player 1", color: Player.availableColors[0]),
        sessionTotal: 14
    )
    .frame(width: 140, height: 140)
    .padding()
}
