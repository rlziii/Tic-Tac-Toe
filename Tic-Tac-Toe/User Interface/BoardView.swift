import SwiftUI

enum AlertType {
    case winning(PlayerType)
    case tie

    var message: String {
        switch self {
        case let .winning(playerType):
            return "Player \(playerType.token) won the game!"
        case .tie:
            return "It's a tie! 😹"
        }
    }
}

class GameEnvironment: ObservableObject {
    @Published var currentPlayer: PlayerType = .x

    @Published var showAlert: Bool = false
    var alertType: AlertType?

    private var boardArray: [[PlayerType?]] = createNewBoard()

    func resetGame() {
        currentPlayer = .x
        showAlert = false
        alertType = nil

        boardArray = Self.createNewBoard()
    }

    func updateBoardPosition(row: Int, column: Int) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        boardArray[row][column] = currentPlayer

        checkForWinner()
        checkForTie()

        currentPlayer = currentPlayer.next
    }

    func checkBoardPositionAt(row: Int, column: Int) -> PlayerType? {
        guard validateIndexAt(row: row, column: column) else {
            assertionFailure("Attempting to check board with index out of bounds...")
            return nil
        }

        return boardArray[row][column]
    }

    private func validateIndexAt(row: Int, column: Int) -> Bool {
        row >= 0 && row < boardArray.count && column >= 0 && column < boardArray[row].count
    }

    func prettyPrintGameBoard() {
        for row in 0...2 {
            for column in 0...2 {
                let selection = boardArray[row][column]
                let terminator = (column == 2) ? "\n" : ""
                print(selection?.token ?? " ", terminator: terminator)
            }
        }
    }

    private func checkForWinner() {
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
                showAlert = true
                break
            }
        }
    }

    private func checkForTie() {
        let boardValues = boardArray.flatMap { row in
            row.map { $0 }
        }

        let hasEmptySpace = boardValues.contains(nil)

        if !hasEmptySpace {
            alertType = .tie
            showAlert = true
        }
    }

    static func createNewBoard() -> [[PlayerType?]] {
        [[nil,nil,nil],
         [nil,nil,nil],
         [nil,nil,nil]]
    }
}

enum PlayerType {
    case x
    case o

    var token: String {
        switch self {
        case .x:
            return "❌"
        case .o:
            return "⭕️"
        }
    }

    var next: PlayerType {
        switch self {
        case .x:
            return .o
        case .o:
            return .x
        }
    }
}

struct BoardView: View {
    @StateObject private var gameEnvironment = GameEnvironment()

    var body: some View {
        VStack {
            Text("Current Player: \(gameEnvironment.currentPlayer.token)")
            BoardGridView(rows: 3, columns: 3, size: 100)
                .environmentObject(gameEnvironment)
        }.alert(isPresented: $gameEnvironment.showAlert) {
            let message: Text? = {
                if let message = gameEnvironment.alertType?.message {
                    return Text(message)
                } else {
                    return nil
                }
            }()

            return Alert(title: Text("Game over!"),
                         message: message,
                         dismissButton: .default(Text("Reset Game"), action: gameEnvironment.resetGame)
            )
        }
    }
}

struct BoardGridView: View {
    let rows: Int
    let columns: Int
    let size: CGFloat

    private var rowsRange: ClosedRange<Int> {
        0...(rows - 1)
    }

    private var columnsRange: ClosedRange<Int> {
        0...(columns - 1)
    }

    var body: some View {
        HStack {
            ForEach(columnsRange, id: \.self) { column in
                VStack {
                    ForEach(rowsRange, id: \.self) { row in
                        BoardSpaceView(size: size, row: row, column: column)
                            .frame(width: size, height: size)
                    }
                }
            }
        }
    }
}

struct BoardSpaceView: View {
    let size: CGFloat
    let row: Int
    let column: Int

    @EnvironmentObject var gameEnvironment: GameEnvironment

    private var selection: PlayerType? {
        gameEnvironment.checkBoardPositionAt(row: row, column: column)
    }

    var body: some View {
        ZStack {
            Rectangle()
                .size(width: size, height: size)

            switch selection {
            case .x, .o:
                Text(selection?.token ?? "")
                    .font(.largeTitle)
                    .frame(width: size, height: size)
            case .none:
                Button(action: {
                    gameEnvironment.updateBoardPosition(row: row, column: column)
                }, label: {
                    Text("")
                        .frame(width: size, height: size)
                })
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
