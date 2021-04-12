import SwiftUI

struct BoardGridView: View {

    // MARK: - Public Properties

    @ObservedObject var game: Game

    // MARK: - Body

    var body: some View {
        HStack {
            ForEach(0..<3) { column in
                VStack {
                    ForEach(0..<3) { row in
                        BoardSpaceView(
                            selection: game.boardTokenFor(row: row, column: column),
                            action: { game.updateBoardTokenFor(row: row, column: column) }
                        )
                    }
                }
            }
        }
        .background(Color.primary)
        .padding(1)
    }
}

// MARK: - Previews

struct BoardGridView_Previews: PreviewProvider {
    static var previews: some View {
        BoardGridView(game: Game())
    }
}
