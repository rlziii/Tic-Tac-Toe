import SwiftUI

class GameEnvironment: ObservableObject {

    // MARK: - Public Properties

    @Published var currentPlayer: PlayerToken = .x
    @Published var endOfGameType: EndOfGameType?

    // MARK: - Private Properties

    private var gameBoard: GameBoard = GameBoard()

    // MARK: - Public Methods

    func resetGame() {
        currentPlayer = .x
        endOfGameType = nil

        gameBoard = GameBoard()
    }

    func boardTokenFor(row: Int, column: Int) -> PlayerToken? {
        let index = gameBoard.indexFor(row: row, column: column)
        return gameBoard[index]
    }

    func updateBoardTokenFor(row: Int, column: Int) {
        let index = gameBoard.indexFor(row: row, column: column)
        updateBoardTokenFor(index: index)
    }

    // MARK: - Private Methods

    private func updateBoardTokenFor(index: Int) {
        gameBoard[index] = currentPlayer

        endOfTurn()
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
        guard endOfGameType == nil else {
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
            let set = Set(path.map { gameBoard[$0] })

            if set.count == 1, let selection = set.first, let selectionUnwrapped = selection {
                endOfGameType = .winning(selectionUnwrapped)
                break
            }
        }
    }

    private func checkForTie() {
        guard endOfGameType == nil else {
            return
        }

        if gameBoard.emptyIndexes().isEmpty {
            endOfGameType = .tie
        }
    }

    private func makeEasyAIMove() {
        guard endOfGameType == nil else {
            return
        }

        let emptyIndexes = gameBoard.emptyIndexes()

        guard let randomIndex = emptyIndexes.randomElement() else {
            return
        }

        updateBoardTokenFor(index: randomIndex)
    }

    // MARK: - Debug Methods

    func prettyPrintGameBoard() {
        for index in 0...8 {
            let selection = gameBoard[index]
            let terminator = (index + 1).isMultiple(of: 3) ? "\n" : ""
            print(selection?.token ?? " ", terminator: terminator)
        }
    }
}
