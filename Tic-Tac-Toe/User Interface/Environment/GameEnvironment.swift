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
//        func minimax(gameBoard: GameBoard, maximizing: Bool, originalPlayer: PlayerToken) -> Int {
//            if board
//        }
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
