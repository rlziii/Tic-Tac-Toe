struct GameBoard {

    // MARK: - Public Properties

    let currentPlayer: PlayerToken

    // MARK: - Private Properties

    private let boardArray: [PlayerToken?]

    // MARK: - Initialization

    init(boardArray: [PlayerToken?] = Array(repeating: nil, count: 9), currentPlayer: PlayerToken = .x) {
        self.boardArray = boardArray
        self.currentPlayer = currentPlayer
    }

    // MARK: - Subscripts

    subscript(row row: Int, column column: Int) -> PlayerToken? {
        let index = indexFor(row: row, column: column)
        return boardArray[index]
    }

    // MARK: - Public Methods

    func makeMove(row: Int, column: Int) -> GameBoard {
        var tempBoardArray = boardArray
        let index = indexFor(row: row, column: column)
        tempBoardArray[index] = currentPlayer
        return GameBoard(boardArray: tempBoardArray, currentPlayer: currentPlayer.next)
    }

    func emptySpaces() -> [(Int, Int)] {
        boardArray.indices
            .filter { boardArray[$0] == nil }
            .map { rowAndColumnFor(index: $0) }
    }

    func isTie() -> Bool {
        !hasWinner() && emptySpaces().isEmpty
    }

    func hasWinner() -> Bool {
        let potentialMatches = [
            [0, 1, 2], // Top row.
            [3, 4, 5], // Middle row.
            [6, 7, 8], // Bottom row.
            [0, 3, 6], // Left column.
            [1, 4, 7], // Center column.
            [2, 5, 8], // Right column.
            [0, 4, 8], // Forward diagonal (\).
            [2, 4, 6]  // Backward diagonal (/).
        ]

        return potentialMatches.contains(where: { boardPositionsMatch($0) })
    }

    // MARK: - Private Methods

    private func indexFor(row: Int, column: Int) -> Int {
        (row * 3) + column
    }

    private func rowAndColumnFor(index: Int) -> (Int, Int) {
        index.quotientAndRemainder(dividingBy: 3)
    }

    private func boardPositionsMatch(_ positions: [Int]) -> Bool {
        let playerTokenSet = Set(positions.map { boardArray[$0] })

        guard playerTokenSet.count == 1, let playerToken = playerTokenSet.first else {
            return false
        }

        return playerToken != nil
    }
}
