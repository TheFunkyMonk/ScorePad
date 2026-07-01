//
//  NumberPadView.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

struct NumberPadView: View {
    let player: Player
    let activePlayer: Player?
    let onConfirm: (Int) -> Void
    let onUndoLast: (Int) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var enteredValue: Int?
    @State private var history: [Int] = []

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let current = activePlayer {
                    PlayerScorePreview(
                        player: current,
                        sessionTotal: history.reduce(0, +)
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 140)
                    .shadow(color: current.darkColor.opacity(0.2), radius: 3, x: 0, y: 2)
                    .padding(.top, 8)

                    Text(current.name)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(current.color)
                }

                Text("\(enteredValue ?? 0)")
                    .font(.system(size: 56, weight: .bold))
                    .foregroundStyle(player.color)

                LazyVGrid(columns: columns, spacing: 12) {
                    ForEach(1...9, id: \.self) { number in
                        numberButton(number)
                    }

                    Color.clear

                    numberButton(0)

                    Button(action: clear) {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .frame(maxWidth: .infinity, minHeight: 60)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(player.color)
                    .shadow(color: player.darkColor.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .padding(.horizontal)

                HStack(spacing: 12) {
                    if let last = history.last {
                        Button(action: undoLast) {
                            Label("Undo +\(last)", systemImage: "arrow.uturn.backward")
                        }
                        .buttonStyle(.bordered)
                        .tint(player.color)
                        .shadow(color: player.darkColor.opacity(0.3), radius: 3, x: 0, y: 2)
                    }

                    Button("Add Points") {
                        if let value = enteredValue {
                            history.append(value)
                            onConfirm(value)
                            enteredValue = nil
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(player.color)
                    .disabled(enteredValue == nil)
                    .shadow(color: player.darkColor.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .padding()

                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func undoLast() {
        guard let last = history.last else { return }
        history.removeLast()
        onUndoLast(last)
    }

    private func numberButton(_ number: Int) -> some View {
        Button(action: { addDigit(number) }) {
            Text("\(number)")
                .font(.title)
                .frame(maxWidth: .infinity, minHeight: 60)
        }
        .buttonStyle(.borderedProminent)
        .tint(player.color)
        .shadow(color: player.darkColor.opacity(0.2), radius: 3, x: 0, y: 1)
    }

    private func addDigit(_ digit: Int) {
        let current = enteredValue ?? 0
        let newValue = current * 10 + digit
        if newValue <= 999 {
            enteredValue = newValue
        }
    }

    private func clear() {
        enteredValue = nil
    }
}

#Preview {
    NumberPadView(
        player: Player(name: "Player 1", color: Player.availableColors[0]),
        activePlayer: Player(name: "Player 1", score: 12, color: Player.availableColors[0]),
        onConfirm: { _ in },
        onUndoLast: { _ in }
    )
}
