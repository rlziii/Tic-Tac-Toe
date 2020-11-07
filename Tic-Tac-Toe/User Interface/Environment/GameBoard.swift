typealias GameBoard = [PlayerToken?]

extension GameBoard {
    private static let rowLength = 3

    static let new = Array(repeating: nil, count: 9)

    subscript(index index: Index) -> Element {
        get {
            assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")
            return self[index]
        }

        set {
            assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")
            self[index] = newValue
        }
    }

    subscript(row row: Index, column column: Index) -> Element {
        get {
            let index = boardIndexFor(row: row, column: column)
            return self[index]
        }

        set {
            let index = boardIndexFor(row: row, column: column)
            self[index] = newValue
        }
    }

    private func boardIndexFor(row: Int, column: Int) -> Int {
        let index = (row * Self.rowLength) + column

        assert(validateIndexFor(row: row, column: column), "Attempting to check board with index out of bounds...")

        return index
    }

    private func validateIndexFor(row: Int, column: Int) -> Bool {
        row >= 0 && row <= (Self.rowLength - 1) && column >= 0 && column <= (Self.rowLength - 1)
    }

    private func validateIndexAt(index: Int) -> Bool {
        index < count
    }
}
