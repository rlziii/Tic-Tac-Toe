struct GameBoard {

    // MARK: - Public Properties

    let currentPlayer: PlayerToken

    // MARK: - Private Properties

    private let boardArray: [PlayerToken?]
    private let length = 3


    // MARK: - Initialization

    init(boardArray: [PlayerToken?] = Array(repeating: nil, count: 9), currentPlayer: PlayerToken = .x) {
        self.boardArray = boardArray
        self.currentPlayer = currentPlayer
    }

    // MARK: - Subscripts

    subscript(index: Int) -> PlayerToken? {
        boardArray[index]
    }

    subscript(row row: Int, column column: Int) -> PlayerToken? {
        let index = indexFor(row: row, column: column)
        return boardArray[index]
    }

    // MARK: - Public Methods

    func indexFor(row: Int, column: Int) -> Int {
        (row * length) + column
    }

    func makeMove(at index: Int) -> GameBoard {
        var tempBoardArray = boardArray
        tempBoardArray[index] = currentPlayer
        return GameBoard(boardArray: tempBoardArray, currentPlayer: currentPlayer.next)
    }

    func emptyIndexes() -> [Int] {
        boardArray.indices.filter { boardArray[$0] == nil }
    }

    func isTie() -> Bool {
        !hasWinner() && emptyIndexes().isEmpty
    }

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

    // MARK: - Private Methods

    private func boardPositionsMatch(_ positions: Int...) -> Bool {
        let playerTokenSet = Set(positions.map { boardArray[$0] })

        guard playerTokenSet.count == 1, let playerToken = playerTokenSet.first else {
            return false
        }

        return playerToken != nil
    }
}
