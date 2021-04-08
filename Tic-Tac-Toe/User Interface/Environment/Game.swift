import SwiftUI

class Game: ObservableObject {

    // MARK: - Public Properties

    @Published private var gameBoard = GameBoard()
    @Published var isMultiplayer = false
    @Published var endOfGameType: EndOfGameType? = nil

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

        if !isMultiplayer, gameBoard.currentPlayer == .o {
            makeAIMove()
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
        guard endOfGameType == nil, let randomIndex = gameBoard.emptyIndexes().randomElement() else {
            return
        }

        updateBoardTokenFor(index: randomIndex)
    }
}
