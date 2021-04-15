import SwiftUI

struct BoardView: View {

    // MARK: - Public Properties

    @StateObject var game: Game

    // MARK: - Body

    var body: some View {
        VStack {
            if (game.isMultiplayer) {
                Text("Current Player: \(game.currentPlayerToken)")
            }

            BoardGridView(game: game)
        }
        .alert(item: $game.endOfGameType, content: endOfGameAlert)
    }

    private func endOfGameAlert(with type: EndOfGameType) -> Alert {
        Alert(
            title: Text("Game over!"),
            message: Text(type.message),
            dismissButton: .default(Text("Reset Game"), action: game.resetGame)
        )
    }
}

// MARK: - Previews

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView(game: Game(isMultiplayer: false))
        BoardView(game: Game(isMultiplayer: true))
    }
}
