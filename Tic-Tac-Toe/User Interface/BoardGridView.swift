import SwiftUI

struct BoardGridView: View {

    // MARK: - Public Properties

    let rows: Int
    let columns: Int
    @ObservedObject var game: Game

    // MARK: - Private Properties

    private var rowsRange: ClosedRange<Int> {
        0...(rows - 1)
    }

    private var columnsRange: ClosedRange<Int> {
        0...(columns - 1)
    }

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
        BoardGridView(rows: 3, columns: 3, game: Game())
    }
}
