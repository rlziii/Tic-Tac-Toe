import SwiftUI

struct BoardView: View {

    // MARK: - Public Properties

    var isMultiplayer: Bool

    // MARK: - Private Properties

    @EnvironmentObject private var gameEnvironment: GameEnvironment

    // MARK: - Body

    var body: some View {
        VStack {
            Text("Current Player: \(gameEnvironment.gameBoard.currentPlayer.token)")

            BoardGridView(rows: 3, columns: 3, size: 100)
                .environmentObject(gameEnvironment)
                .padding()

            if (gameEnvironment.isMultiplayer) {
                Picker("Multiplayer Mode", selection: $gameEnvironment.multiplayerMode) {
                    ForEach(MultiplayerMode.allCases) { mode in
                        Text(mode.displayText).tag(mode)
                    }
                }.pickerStyle(SegmentedPickerStyle())
            } else {
                Picker("Difficulty", selection: $gameEnvironment.difficulty) {
                    ForEach(DifficultyMode.allCases) { mode in
                        Text(mode.displayText).tag(mode)
                    }
                }.pickerStyle(SegmentedPickerStyle())

            }
        }.alert(item: $gameEnvironment.endOfGameType) { endOfGameType in
            Alert(title: Text("Game over!"),
                  message: Text(endOfGameType.message),
                  dismissButton: .default(Text("Reset Game"), action: gameEnvironment.resetGame)
            )
        }.onAppear {
            gameEnvironment.isMultiplayer = isMultiplayer
        }
    }
}

// MARK: - Previews

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(isMultiplayer: false)
            .environmentObject(GameEnvironment())
    }
}
