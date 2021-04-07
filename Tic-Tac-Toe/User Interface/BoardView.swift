import SwiftUI

struct BoardView: View {

    // MARK: - Private Properties

    @StateObject private var game: Game

    // MARK: - Body

    var body: some View {
        VStack {
            if (game.isMultiplayer) {
                Text("Current Player: \(game.gameBoard.currentPlayer.token)")
            }

            BoardGridView(rows: 3, columns: 3, size: 100)
                .padding()
                .environmentObject(game)
        }.alert(item: $game.endOfGameType, content: endOfGameAlert)
    }

    init(isMultiplayer: Bool) {
        _game = StateObject(wrappedValue: Game(isMultiplayer: isMultiplayer))
    }

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
