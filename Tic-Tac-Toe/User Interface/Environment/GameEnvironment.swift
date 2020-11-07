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
        gameBoard = gameBoard.makeMove(at: index)

        endOfTurn()
    }

    private func endOfTurn() {
        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next

        if currentPlayer == .o {
//            makeEasyAIMove()
            makeHardAIMove()
        }
    }

    private func checkForWinner() {
        guard endOfGameType == nil else {
            return
        }

        if gameBoard.hasWinner() {
            endOfGameType = .winning(currentPlayer)
        }
    }

    private func checkForTie() {
        guard endOfGameType == nil else {
            return
        }

        if gameBoard.isTie() {
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

    private func makeHardAIMove() {
        guard endOfGameType == nil else {
            return
        }

        func minimax(gameBoard: GameBoard, maximizing: Bool, originalPlayer: PlayerToken) -> Int {
            if gameBoard.hasWinner() && originalPlayer == gameBoard.currentPlayer.next {
                return 1
            } else if gameBoard.hasWinner() && originalPlayer != gameBoard.currentPlayer.next {
                return -1
            } else if gameBoard.isTie() {
                return 0
            }

            if maximizing {
                var bestEvaluation = Int.min

                for index in gameBoard.emptyIndexes() {
                    let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: false, originalPlayer: originalPlayer)
                    bestEvaluation = max(result, bestEvaluation)
                }

                return bestEvaluation
            } else {
                var worstEvaluation = Int.max

                for index in gameBoard.emptyIndexes() {
                    let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: true, originalPlayer: originalPlayer)
                    worstEvaluation = min(result, worstEvaluation)
                }

                return worstEvaluation
            }
        }

        var bestEvaluation = Int.min
        var bestMove = -1

        for index in gameBoard.emptyIndexes() {
            let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: false, originalPlayer: gameBoard.currentPlayer)
            if result > bestEvaluation {
                bestEvaluation = result
                bestMove = index
            }
        }

        updateBoardTokenFor(index: bestMove)
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
