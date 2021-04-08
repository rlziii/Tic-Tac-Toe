import SwiftUI

struct BoardView: View {

    // MARK: - Public Properties

    let isMultiplayer: Bool

    // MARK: - Private Properties

    @StateObject private var game = Game()

    // MARK: - Body

    var body: some View {
        VStack {
            if (game.isMultiplayer) {
                Text("Current Player: \(game.gameBoard.currentPlayer.token)")
            }

            BoardGridView(rows: 3, columns: 3, game: game)
                .environmentObject(game)
                .padding()
        }
        .onAppear { game.isMultiplayer = isMultiplayer }
        .alert(item: $game.endOfGameType, content: endOfGameAlert)
    }

    // MARK: - Private Methods

    private func endOfGameAlert(with type: EndOfGameType) -> Alert {
        Alert(title: Text("Game over!"),
              message: Text(type.message),
              dismissButton: .default(Text("Reset Game"), action: game.resetGame)
        )
    }
}

// MARK: - Previews

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(isMultiplayer: false)
    }
}
