import SwiftUI

struct BoardGridView: View {

    // MARK: - Public Properties

    let rows: Int
    let columns: Int
    let size: CGFloat

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
                        BoardSpaceView(size: size, row: row, column: column)
                            .frame(width: size, height: size)
                    }
                }
            }
        }.background(Color.primary)
    }
}

// MARK: - Previews

struct BoardGridView_Previews: PreviewProvider {
    static var previews: some View {
        BoardGridView(rows: 3, columns: 3, size: 100)
            .environmentObject(GameEnvironment())
    }
}
