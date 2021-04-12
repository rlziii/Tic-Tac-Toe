/// The structure that represents the Tic-Tac-Toe game board.
struct GameBoard {

    // MARK: - Public Properties

    /// The token that is next to make a move in the game.
    let currentPlayer: PlayerToken

    // MARK: - Private Properties

    /// The underlying data structure that represents the moves made during the game.
    private let boardArray: [PlayerToken?]

    // MARK: - Initialization

    /// - Note: The Tic-Tac-Toe board is represented as a 1D array: [0, 1, 2, 3, 4, 5, 6, 7, 8]
    init(boardArray: [PlayerToken?] = Array(repeating: nil, count: 9), currentPlayer: PlayerToken = .x) {
        self.boardArray = boardArray
        self.currentPlayer = currentPlayer
    }

    // MARK: - Subscripts

    /// A convenience subscript to retrieve the `PlayerToken` at the given 2D index.
    subscript(row row: Int, column column: Int) -> PlayerToken? {
        let index = indexFor(row: row, column: column)
        return boardArray[index]
    }

    // MARK: - Public Methods

    // ...

    // MARK: - Private Methods

    /// Converts a 2D (row, column) reference to a 1D reference index in the `boardArray`.
    ///
    /// - Note: The Tic-Tac-Toe `boardArray`, seen another way, looks like this:
    ///
    /// [0, 1, 2,
    ///
    ///  3, 4, 5,
    ///
    ///  6, 7, 8]
    ///
    /// Therefore, for a 0-indexed (row, column) reference of (1, 2) we would expect 5 as the 1D index.
    /// With [row = 1] and [column = 2], we run the equation: (1 * 3) + 2 = 3 + 2 = 5.
    private func indexFor(row: Int, column: Int) -> Int {
        (row * 3) + column
    }
}
