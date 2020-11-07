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
        getBoardPositionAt(row: row, column: column)
    }

    func updateBoardPosition(index: Int) {
        assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")

        setBoardPositionAt(index: index, newValue: currentPlayer)

        endOfTurnChecks()
    }

    func updateBoardPosition(row: Int, column: Int) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        setBoardPositionAt(row: row, column: column, newValue: currentPlayer)

        endOfTurnChecks()
    }

    // MARK: - Private Methods

    private func boardPositionIndexAt(row: Int, column: Int) -> Int {
        let rowLength = 3
        return (row * rowLength) + column
    }

    private func getBoardPositionAt(row: Int, column: Int) -> PlayerToken? {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        let index = boardPositionIndexAt(row: row, column: column)
        return boardArray[index]
    }

    private func setBoardPositionAt(row: Int, column: Int, newValue: PlayerToken?) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        let index = boardPositionIndexAt(row: row, column: column)
        boardArray[index] = newValue
    }

    private func setBoardPositionAt(index: Int, newValue: PlayerToken?) {
        assert(validateIndexAt(index: index), "Attempting to check board with index out of bounds...")

        boardArray[index] = newValue
    }

    private func endOfTurnChecks() {
        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next

        if currentPlayer == .o {
            makeEasyAIMove()
        }
    }

    private func makeEasyAIMove() {
        let emptyIndexes = boardArray.enumerated().compactMap { $1 == nil ? $0 : nil }

        guard let randomIndex = emptyIndexes.randomElement() else {
            return
        }

        updateBoardPosition(index: randomIndex)
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

    private func validateIndexAt(index: Int) -> Bool {
        index < boardArray.count
    }

    // MARK: - Private Type Methods

    private static func createNewBoard() -> [PlayerToken?] {
        Array(repeating: nil, count: 9)
    }

    // MARK: - Debug Methods

    func prettyPrintGameBoard() {
        for index in 0...(boardArray.count - 1) {
            let selection = boardArray[index]
            let terminator = (index + 1).isMultiple(of: 3) ? "\n" : ""
            print(selection?.token ?? " ", terminator: terminator)
        }
    }
}
