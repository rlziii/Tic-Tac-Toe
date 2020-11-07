import SwiftUI

class GameEnvironment: ObservableObject {

    // MARK: - Public Properties

    @Published var currentPlayer: PlayerToken = .x
    @Published var alertType: AlertType?

    // MARK: - Private Properties

    private var boardArray: [PlayerToken?] = createNewBoard()

    // MARK: - Public Methods

    func resetGame() {
        currentPlayer = .x
        alertType = nil

        boardArray = Self.createNewBoard()
    }

    func checkBoardPositionAt(row: Int, column: Int) -> PlayerToken? {
        guard validateIndexAt(row: row, column: column) else {
            assertionFailure("Attempting to check board with index out of bounds...")
            return nil
        }

        return getBoardPositionAt(row: row, column: column)
    }

    func updateBoardPosition(row: Int, column: Int) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        setBoardPositionAt(row: row, column: column, newValue: currentPlayer)

        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next

        if currentPlayer == .o {
            makeEasyAIMove()
        }
    }

    // MARK: - Private Methods

    private func getBoardPositionAt(row: Int, column: Int) -> PlayerToken? {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        let rowLength = 3
        let index = (row * rowLength) + column
        return boardArray[index]
    }

    private func setBoardPositionAt(row: Int, column: Int, newValue: PlayerToken?) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        let rowLength = 3
        let index = (row * rowLength) + column
        boardArray[index] = newValue
    }

    private func makeEasyAIMove() {
        var emptySpaces = [(Int, Int)]()

        for row in 0...2 {
            for column in 0...2 {
                if getBoardPositionAt(row: row, column: column) == nil {
                    emptySpaces.append((row, column))
                }
            }
        }

        guard let (randomRow, randomColumn) = emptySpaces.randomElement() else {
            return
        }

        updateBoardPosition(row: randomRow, column: randomColumn)
    }

    private func checkForWinner() {
        guard alertType == nil else {
            return
        }

        /*
         0 1 2
         3 4 5
         6 7 8
         */

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
            let set = Set(path.map { boardArray[$0] })

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

        if !boardArray.contains(nil) {
            alertType = .tie
        }
    }

    private func validateIndexAt(row: Int, column: Int) -> Bool {
        row >= 0 && row <= 2 && column >= 0 && column <= 2
    }

    // MARK: - Private Type Methods

    private static func createNewBoard() -> [PlayerToken?] {
        Array(repeating: nil, count: 9)
    }

    // MARK: - Debug Methods

    func prettyPrintGameBoard() {
        for index in 0...boardArray.count {
            let selection = boardArray[index]
            let terminator = (index + 1).isMultiple(of: 3) ? "\n" : ""
            print(selection?.token ?? " ", terminator: terminator)
        }
    }
}
