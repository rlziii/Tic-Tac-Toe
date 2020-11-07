struct GameBoard {

    // MARK: - Private Properties

    private let boardArray: [PlayerToken?]
    let currentPlayer: PlayerToken
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

    func makeMove(at index: Int) -> GameBoard {
        var tempBoardArray = boardArray
        tempBoardArray[index] = currentPlayer
        return GameBoard(boardArray: tempBoardArray, currentPlayer: currentPlayer.next)
    }

    // MARK: - Private Methods
    
    private func validate(_ index: Int) -> Bool {
        index < boardArray.count
    }

    private func validate(row: Int, column: Int) -> Bool {
        row >= 0 && row <= (Self.rowLength - 1) && column >= 0 && column <= (Self.rowLength - 1)
    }
}
