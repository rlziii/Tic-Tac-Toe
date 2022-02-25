import SwiftUI

struct BoardGridView: View {

    // MARK: - Public Properties

    @ObservedObject var game: Game

    // MARK: - Private Properties

    private let columnsRange = 0...2
    private let rowsRange = 0...2

    // MARK: - Body

    var body: some View {
        HStack {
            ForEach(columnsRange, id: \.self) { column in
                VStack {
                    ForEach(rowsRange, id: \.self) { row in
                        BoardSpaceView(
                            selection: game.boardTokenFor(row: row, column: column),
                            action: { game.updateBoardTokenFor(row: row, column: column) }
                        )
                    }
                }
            }
        }.background(Color.primary)
    }
}

// MARK: - Previews

struct BoardGridView_Previews: PreviewProvider {
    static var previews: some View {
        BoardGridView(game: Game())
    }
}
