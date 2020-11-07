struct GameBoard {

    // MARK: - Private Properties

    private var boardArray: [PlayerToken?] = Array(repeating: nil, count: 9)
    private static let rowLength = 3

    // MARK: - Public Subscripts

    subscript(index: Int) -> PlayerToken? {
        get {
            assert(validate(index), "Attempting to check board with index out of bounds...")
            return boardArray[index]
        }

        set {
            assert(validate(index), "Attempting to check board with index out of bounds...")
            boardArray[index] = newValue
        }
    }

    // MARK: - Public Methods

    func hasWinner() -> Bool {
        (boardArray[0] != nil && boardArray[0] == boardArray[1] && boardArray[0] == boardArray[2]) || // Top row.
        (boardArray[3] != nil && boardArray[3] == boardArray[4] && boardArray[3] == boardArray[5]) || // Middle row.
        (boardArray[6] != nil && boardArray[6] == boardArray[7] && boardArray[6] == boardArray[8]) || // Bottom row.
        (boardArray[0] != nil && boardArray[0] == boardArray[3] && boardArray[0] == boardArray[6]) || // Left column.
        (boardArray[1] != nil && boardArray[1] == boardArray[4] && boardArray[1] == boardArray[7]) || // Center column.
        (boardArray[2] != nil && boardArray[2] == boardArray[5] && boardArray[2] == boardArray[8]) || // Right column.
        (boardArray[0] != nil && boardArray[0] == boardArray[4] && boardArray[0] == boardArray[8]) || // Forward diagonal (\).
        (boardArray[2] != nil && boardArray[2] == boardArray[4] && boardArray[2] == boardArray[6])    // Backward diagonal (/).
    }

    func isTie() -> Bool {
        !hasWinner() && emptyIndexes().isEmpty
    }

    func emptyIndexes() -> [Int] {
        boardArray.indices.filter { boardArray[$0] == nil }
    }

    func indexFor(row: Int, column: Int) -> Int {
        let index = (row * Self.rowLength) + column

        assert(validate(row: row, column: column), "Attempting to check board with index out of bounds...")

        return index
    }

    // MARK: - Private Methods
    
    private func validate(_ index: Int) -> Bool {
        index < boardArray.count
    }

    private func validate(row: Int, column: Int) -> Bool {
        row >= 0 && row <= (Self.rowLength - 1) && column >= 0 && column <= (Self.rowLength - 1)
    }
}
