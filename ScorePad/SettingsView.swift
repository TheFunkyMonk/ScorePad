//
//  SettingsView.swift
//  ScorePad
//
//  Created by R.J. LaCount on 6/30/26.
//

import SwiftUI

struct SettingsView: View {
    @Bindable var game: GameViewModel
    let systemColorScheme: ColorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showingResetConfirm = false

    var resolvedColorScheme: ColorScheme {
        game.colorSchemePreference.colorScheme ?? systemColorScheme
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Players") {
                    Stepper(
                        "^[\(game.players.count) Player](inflect: true)",
                        value: Binding(
                            get: { game.players.count },
                            set: { game.setPlayerCount($0) }
                        ),
                        in: 1...8
                    )
                }

                Section("Appearance") {
                    ForEach(ColorSchemePreference.allCases) { preference in
                        HStack {
                            Label(preference.rawValue, systemImage: preference.icon)
                            Spacer()
                            if game.colorSchemePreference == preference {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.tint)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            game.colorSchemePreference = preference
                        }
                    }
                }

                Section {
                    Button(role: .destructive) {
                        showingResetConfirm = true
                    } label: {
                        HStack {
                            Spacer()
                            Text("Reset to Defaults")
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .preferredColorScheme(resolvedColorScheme)
        }
        .confirmationDialog(
            "Reset everything to default settings?",
            isPresented: $showingResetConfirm,
            titleVisibility: .visible
        ) {
            Button("Reset to Defaults", role: .destructive) {
                game.resetToDefaults()
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }
}

#Preview {
    SettingsView(game: GameViewModel(), systemColorScheme: .light)
}
