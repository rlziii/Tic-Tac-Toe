import SwiftUI

class GameEnvironment: ObservableObject {

    // MARK: - Public Properties

    @Published var currentPlayer: PlayerToken = .x
    @Published var alertType: AlertType?

    // MARK: - Private Properties

    private var boardArray: [[PlayerToken?]] = createNewBoard()

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

        return boardArray[row][column]
    }

    func updateBoardPosition(row: Int, column: Int) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        boardArray[row][column] = currentPlayer

        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next

        if currentPlayer == .o {
            makeEasyAIMove()
        }
    }

    // MARK: - Private Methods

    private func makeEasyAIMove() {
        var emptySpaces = [(Int, Int)]()

        for row in 0...2 {
            for column in 0...2 {
                if boardArray[row][column] == nil {
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

        let winningPaths = [
            [(0,0),(0,1),(0,2)], // Top row.
            [(1,0),(1,1),(1,2)], // Middle row.
            [(2,0),(2,1),(2,2)], // Bottom row.
            [(0,0),(1,0),(2,0)], // Left column.
            [(0,1),(1,1),(2,1)], // Center column.
            [(0,2),(1,2),(2,2)], // Right column.
            [(0,0),(1,1),(2,2)], // Top-left-to-bottom-right diagonal (\).
            [(0,2),(1,1),(2,0)], // Top-right-to-bottom-left diagonal (/).
        ]

        for path in winningPaths {
            let set = Set(path.map { boardArray[$0][$1] })

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

        let boardValues = boardArray.flatMap { row in
            row.map { $0 }
        }

        let hasEmptySpace = boardValues.contains(nil)

        if !hasEmptySpace {
            alertType = .tie
        }
    }

    private func validateIndexAt(row: Int, column: Int) -> Bool {
        row >= 0 && row < boardArray.count && column >= 0 && column < boardArray[row].count
    }

    // MARK: - Private Type Methods

    private static func createNewBoard() -> [[PlayerToken?]] {
        [[nil,nil,nil],
         [nil,nil,nil],
         [nil,nil,nil]]
    }

    // MARK: - Debug Methods

    func prettyPrintGameBoard() {
        for row in 0...2 {
            for column in 0...2 {
                let selection = boardArray[row][column]
                let terminator = (column == 2) ? "\n" : ""
                print(selection?.token ?? " ", terminator: terminator)
            }
        }
    }
}
