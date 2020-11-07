import SwiftUI

class GameEnvironment: ObservableObject {

    // MARK: - Public Properties

    @Published var currentPlayer: PlayerToken = .x
    @Published var alertType: AlertType?

    // MARK: - Private Properties

    private var gameBoard: GameBoard = .new

    // MARK: - Public Methods

    func resetGame() {
        currentPlayer = .x
        alertType = nil

        gameBoard = .new
    }

    func boardTokenFor(row: Int, column: Int) -> PlayerToken? {
        let index = boardIndexFor(row: row, column: column)
        return gameBoard[index: index]
    }

    func updateBoardTokenFor(row: Int, column: Int) {
        let index = boardIndexFor(row: row, column: column)
        gameBoard[index: index] = currentPlayer

        endOfTurn()
    }

    // MARK: - Private Methods

    private func boardIndexFor(row: Int, column: Int) -> Int {
        let rowLength = 3

        let index = (row * rowLength) + column

        assert(validateIndexFor(row: row, column: column), "Attempting to check board with index out of bounds...")

        return index
    }

    private func validateIndexFor(row: Int, column: Int) -> Bool {
        let rowLength = 3

        return row >= 0 && row <= (rowLength - 1) && column >= 0 && column <= (rowLength - 1)
    }

    private func updateBoardTokenFor(index: Int) {
        updateBoardTokenFor(index: index, newValue: currentPlayer)

        endOfTurn()
    }

    private func updateBoardTokenFor(index: Int, newValue: PlayerToken?) {
        gameBoard[index: index] = newValue
    }

    private func endOfTurn() {
        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next

        if currentPlayer == .o {
            makeEasyAIMove()
        }
    }

    private func checkForWinner() {
        guard alertType == nil else {
            return
        }

        let winningPaths = [
            [0, 1, 2], // Top row.
            [3, 4, 5], // Middle row.
            [6, 7, 8], // Bottom row.
            [0, 3, 6], // Left column.
            [1, 4, 7], // Center column.
            [2, 5, 8], // Right column.
            [0, 4, 8], // Top-left-to-bottom-right diagonal (\).
            [2, 4, 6], // Top-right-to-bottom-left diagonal (/).
        ]

        for path in winningPaths {
            let set = Set(path.map { gameBoard[index: $0] })

            if set.count == 1, let selection = set.first, let selectionUnwrapped = selection {
                alertType = .winning(selectionUnwrapped)
                break
            }
        }
    }

    private func checkForTie() {
        guard alertType == nil else {
            return
        }

        if !gameBoard.contains(nil) {
            alertType = .tie
        }
    }

    private func makeEasyAIMove() {
        let emptyIndexes = gameBoard.enumerated().compactMap { $1 == nil ? $0 : nil }

        guard let randomIndex = emptyIndexes.randomElement() else {
            return
        }

        updateBoardTokenFor(index: randomIndex)
    }

    // MARK: - Debug Methods

    func prettyPrintGameBoard() {
        for index in 0...(gameBoard.count - 1) {
            let selection = gameBoard[index: index]
            let terminator = (index + 1).isMultiple(of: 3) ? "\n" : ""
            print(selection?.token ?? " ", terminator: terminator)
        }
    }
}
