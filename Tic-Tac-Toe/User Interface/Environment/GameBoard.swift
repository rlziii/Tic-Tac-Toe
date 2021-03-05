struct GameBoard {

    // MARK: - Public Properties

    let currentPlayer: PlayerToken

    // MARK: - Private Properties

    private let boardArray: [PlayerToken?]
    private static let rowLength = 3

    init(boardArray: [PlayerToken?] = Array(repeating: nil, count: 9), currentPlayer: PlayerToken = .x) {
        self.boardArray = boardArray
        self.currentPlayer = currentPlayer
    }

    // MARK: - Public Subscripts

    subscript(index: Int) -> PlayerToken? {
        assert(validate(index), "Attempting to check board with index out of bounds...")
        return boardArray[index]
    }

    // MARK: - Public Methods
    
    func hasWinner() -> Bool {
        boardPositionsMatch(0, 1, 2) || // Top row.
        boardPositionsMatch(3, 4, 5) || // Middle row.
        boardPositionsMatch(6, 7, 8) || // Bottom row.
        boardPositionsMatch(0, 3, 6) || // Left column.
        boardPositionsMatch(1, 4, 7) || // Center column.
        boardPositionsMatch(2, 5, 8) || // Right column.
        boardPositionsMatch(0, 4, 8) || // Forward diagonal (\).
        boardPositionsMatch(2, 4, 6)    // Backward diagonal (/).
    }

    private func boardPositionsMatch(_ positions: Int...) -> Bool {
        let playerTokenSet = Set(positions.map { boardArray[$0] })

        guard playerTokenSet.count == 1, let playerToken = playerTokenSet.first else {
            return false
        }

        return playerToken != nil
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

    func makeMove(at index: Int) -> GameBoard {
        assert(validate(index), "Attempting to check board with index out of bounds...")

        var tempBoardArray = boardArray
        tempBoardArray[index] = currentPlayer
        return GameBoard(boardArray: tempBoardArray, currentPlayer: currentPlayer.next)
    }

    // MARK: - Private Methods
    
    private func validate(_ index: Int) -> Bool {
        index >= 0 && index < boardArray.count
    }

    private func validate(row: Int, column: Int) -> Bool {
        row >= 0 && row <= (Self.rowLength - 1) && column >= 0 && column <= (Self.rowLength - 1)
    }
}
