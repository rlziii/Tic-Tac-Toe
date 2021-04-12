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
            .map { $0.quotientAndRemainder(dividingBy: 3) }
    }

    func isTie() -> Bool {
        !hasWinner() && !hasEmptySpaces()
    }

    func hasWinner() -> Bool {
        checkLineForWinner(0, 1, 2) ||
        checkLineForWinner(3, 4, 5) ||
        checkLineForWinner(6, 7, 8) ||
        checkLineForWinner(0, 3, 6) ||
        checkLineForWinner(1, 4, 7) ||
        checkLineForWinner(2, 5, 8) ||
        checkLineForWinner(0, 4, 8) ||
        checkLineForWinner(2, 4, 6)
    }

    // MARK: - Private Methods

    private func indexFor(row: Int, column: Int) -> Int {
        (row * 3) + column
    }

    private func checkLineForWinner(_ first: Int, _ second: Int, _ third: Int) -> Bool {
        (boardArray[first] != nil) &&
        (boardArray[first] == boardArray[second]) &&
        (boardArray[second] == boardArray[third])
    }

    private func hasEmptySpaces() -> Bool {
        boardArray.contains(nil)
    }
}
