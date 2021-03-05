import SwiftUI

class GameEnvironment: ObservableObject {

    // MARK: - Public Properties

    @Published var gameBoard: GameBoard = GameBoard()
    @Published var endOfGameType: EndOfGameType? = nil
    
    @Published var isMultiplayer = false
    @Published var difficulty: DifficultyMode = .easyMode

    // MARK: - Public Methods

    func resetGame() {
        gameBoard = GameBoard()
        endOfGameType = nil
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

        if !isMultiplayer {
            if gameBoard.currentPlayer == .o {
                makeAIMove(difficulty: difficulty)
            }
        }
    }

    private func checkForWinner() {
        guard endOfGameType == nil else {
            return
        }

        if gameBoard.hasWinner() {
            endOfGameType = .winning(gameBoard.currentPlayer.next)
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

    private func chooseRandomMove() -> Int {
        assert(!gameBoard.emptyIndexes().isEmpty)

        return gameBoard.emptyIndexes().randomElement()!
    }

    private func chooseBestMove() -> Int {
        func minimax(gameBoard: GameBoard, maximizing: Bool, originalPlayer: PlayerToken, alpha: Int, beta: Int) -> Int {
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
                    let alpha = max(bestEvaluation, alpha)

                    if alpha >= beta {
                        break
                    }

                    let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: false, originalPlayer: originalPlayer, alpha: alpha, beta: beta)
                    bestEvaluation = max(result, bestEvaluation)
                }

                return bestEvaluation
            } else {
                var worstEvaluation = Int.max

                for index in gameBoard.emptyIndexes() {
                    let beta = min(worstEvaluation, beta)

                    if alpha >= beta {
                        break
                    }

                    let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: true, originalPlayer: originalPlayer, alpha: alpha, beta: beta)
                    worstEvaluation = min(result, worstEvaluation)
                }

                return worstEvaluation
            }
        }

        var bestEvaluation = Int.min
        var bestMove = -1

        for index in gameBoard.emptyIndexes() {
            let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: false, originalPlayer: gameBoard.currentPlayer, alpha: Int.min, beta: Int.max)
            if result > bestEvaluation {
                bestEvaluation = result
                bestMove = index
            }
        }

        return bestMove
    }

    private func makeAIMove(difficulty: DifficultyMode) {
        guard endOfGameType == nil, !gameBoard.emptyIndexes().isEmpty else {
            return
        }

        let index: Int = {
            switch difficulty {
            case .easyMode:
                return chooseRandomMove()
            case .hardMode:
                let random = Int.random(in: 0...9)
                if random > 7 {
                    // Choose a random move 20% of the time.
                    return chooseRandomMove()
                } else {
                    // Choose the best move 80% of the time.
                    return chooseBestMove()
                }
            case .impossibleMode:
                return chooseBestMove()
            }
        }()

        updateBoardTokenFor(index: index)
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
