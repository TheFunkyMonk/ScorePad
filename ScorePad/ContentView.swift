import SwiftUI

struct ContentView: View {
    let systemColorScheme: ColorScheme

    @State private var game = GameViewModel()
    @State private var activePlayer: Player?
    @State private var lastActivePlayerID: Player.ID?
    @State private var showingResetConfirm = false
    @State private var showingSettings = false
    @State private var renamingPlayerID: Player.ID?
    @State private var renameText = ""
    @FocusState private var renameFieldFocused: Bool

    let columns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var activePlayerCurrent: Player? {
        guard let id = lastActivePlayerID else { return nil }
        return game.players.first(where: { $0.id == id })
    }

    var resolvedColorScheme: ColorScheme {
        game.colorSchemePreference.colorScheme ?? systemColorScheme
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .secondarySystemBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 0) {
                    Text("ScorePad")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 8)
                        .padding(.bottom, 28)

                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(game.players) { player in
                            VStack(spacing: 6) {
                                Button {
                                    renameText = player.name
                                    renamingPlayerID = player.id
                                } label: {
                                    Text(player.name)
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundStyle(.primary)
                                        .lineLimit(1)
                                        .truncationMode(.tail)
                                }
                                .buttonStyle(.plain)

                                PlayerScoreCard(
                                    player: player,
                                    onTap: {
                                        activePlayer = player
                                        lastActivePlayerID = player.id
                                    },
                                    onUndoLastSession: { game.undoLastSession(for: player.id) }
                                )
                                .aspectRatio(1, contentMode: .fit)
                                .id(player.id)
                                .shadow(color: player.darkColor.opacity(0.2), radius: 3, x: 0, y: 2)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 120)
                }
                .padding(.top)
            }

            GlassEffectContainer {
                HStack(spacing: 0) {
                    Button {
                        showingSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(width: 72, height: 52)
                            .tint(.primary.opacity(0.6))
                    }

                    Divider()
                        .frame(height: 30)

                    Button {
                        showingResetConfirm = true
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .font(.title3)
                            .fontWeight(.medium)
                            .frame(width: 72, height: 52)
                            .tint(.primary.opacity(0.6))
                    }
                    .disabled(game.players.allSatisfy { $0.score == 0 })
                }
                .glassEffect(in: .capsule)
            }
            .padding(.bottom, 36)
        }
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(resolvedColorScheme)
        .confirmationDialog(
            "Reset all scores to zero?",
            isPresented: $showingResetConfirm,
            titleVisibility: .visible
        ) {
            Button("Reset Game", role: .destructive) {
                game.resetGame()
            }
            Button("Cancel", role: .cancel) {}
        }
        .alert("Rename Player", isPresented: Binding(
            get: { renamingPlayerID != nil },
            set: { if !$0 { renamingPlayerID = nil } }
        )) {
            TextField("Player name", text: $renameText)
                .focused($renameFieldFocused)
            Button("Save") {
                if let id = renamingPlayerID {
                    game.renamePlayer(id, to: renameText)
                }
                renamingPlayerID = nil
            }
            Button("Cancel", role: .cancel) {
                renamingPlayerID = nil
            }
        }
        .onChange(of: renamingPlayerID) { _, newValue in
            if newValue != nil {
                renameFieldFocused = true
            }
        }
        .sheet(isPresented: $showingSettings) {
            SettingsView(game: game, systemColorScheme: systemColorScheme)
                .presentationDetents([.fraction(0.88)])
                .presentationDragIndicator(.visible)
        }
        .sheet(
            item: $activePlayer,
            onDismiss: {
                if let id = lastActivePlayerID {
                    game.closeSession(for: id)
                }
            }
        ) { player in
            NumberPadView(
                player: player,
                activePlayer: activePlayerCurrent ?? player,
                onConfirm: { points in
                    game.addScore(points, to: player.id)
                },
                onUndoLast: { points in
                    game.undoLastEntry(points, for: player.id)
                }
            )
            .presentationBackground(player.color.mix(with: .white, by: 0.5).opacity(0.15))
            .presentationDetents([.large])
            .preferredColorScheme(resolvedColorScheme)
        }
    }
}

#Preview {
    ContentView(systemColorScheme: .dark)
}
