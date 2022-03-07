import SwiftUI

struct BoardView: View {

    // MARK: - Private Properties

    @StateObject private var game: Game

    // MARK: - Initialization

    init(mode: GameMode) {
        _game = StateObject(wrappedValue: Game(mode: mode))
    }

    // MARK: - Body

    var body: some View {
        VStack {
            switch game.mode {
            case .onePlayer:
                Text("Current Player: \(game.currentPlayerToken)")
            case .twoPlayer:
                EmptyView()
            }

            BoardGridView(game: game)
                .padding()
        }
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
        BoardView(mode: .onePlayer(.easy))
    }
}
