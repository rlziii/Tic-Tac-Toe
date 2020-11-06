import SwiftUI

struct BoardView: View {

    // MARK: - Private Properties

    @EnvironmentObject private var gameEnvironment: GameEnvironment

    // MARK: - Body

    var body: some View {
        VStack {
            Text("Current Player: \(gameEnvironment.currentPlayer.token)")
            BoardGridView(rows: 3, columns: 3, size: 100)
                .environmentObject(gameEnvironment)
        }.alert(item: $gameEnvironment.alertType) { alertType in
            Alert(title: Text("Game over!"),
                  message: Text(alertType.message),
                  dismissButton: .default(Text("Reset Game"), action: gameEnvironment.resetGame)
            )
        }
    }
}

// MARK: - Previews

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
            .environmentObject(GameEnvironment())
    }
}
