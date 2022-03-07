import SwiftUI

enum GameMode {
    case onePlayer(GameDifficulty)
    case twoPlayer
}

enum GameDifficulty {
    case easy
    case hard
}

class Game: ObservableObject {

    // MARK: - Public Properties

    @Published private var gameBoard = GameBoard()
    @Published var mode: GameMode
    @Published var endOfGameType: EndOfGameType? = nil

    init(mode: GameMode) {
        self.mode = mode
    }

    var currentPlayerToken: String {
        gameBoard.currentPlayer.token
    }

    // MARK: - Public Methods

    func resetGame() {
        gameBoard = GameBoard()
        endOfGameType = nil
    }

    func boardTokenFor(row: Int, column: Int) -> PlayerToken? {
        gameBoard[row: row, column: column]
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

        switch mode {
        case .onePlayer:
            if gameBoard.currentPlayer == .o {
                makeAIMove()
            }
        case .twoPlayer:
            break // Do nothing.
        }
    }

    private func checkForWinner() {
        guard endOfGameType == nil else {
            return
        }

        if gameBoard.hasWinner() {
            endOfGameType = .winner(gameBoard.currentPlayer.next)
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

    private func makeAIMove() {
        guard endOfGameType == nil, !gameBoard.emptyIndexes().isEmpty else {
            return
        }

        let index: Int

        switch mode {
        case .onePlayer(let gameDifficulty):
            switch gameDifficulty {
            case .easy:
                index = chooseRandomMove()
            case .hard:
                index = chooseBestMove()
            }
        case .twoPlayer:
            preconditionFailure("Should not attempt AI move in two-player game.")
        }

        updateBoardTokenFor(index: index)
    }

    private func chooseRandomMove() -> Int {
        assert(!gameBoard.emptyIndexes().isEmpty)

        return gameBoard.emptyIndexes().randomElement()!
    }

    private func chooseBestMove() -> Int {
        // Local function.
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
        var bestMoveIndex = -1

        for index in gameBoard.emptyIndexes() {
            let result = minimax(gameBoard: gameBoard.makeMove(at: index), maximizing: false, originalPlayer: gameBoard.currentPlayer, alpha: Int.min, beta: Int.max)
            if result > bestEvaluation {
                bestEvaluation = result
                bestMoveIndex = index
            }
        }

        return bestMoveIndex
    }
}
