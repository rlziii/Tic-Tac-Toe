import SwiftUI

class GameEnvironment: ObservableObject {
    @Published var currentPlayer: PlayerType = .x

    @Published var showWinnerAlert: Bool = false
    @Published var winningPlayer: PlayerType?

    var boardArray: [[BoardSpaceSelection?]] = [
        [nil,nil,nil],
        [nil,nil,nil],
        [nil,nil,nil]
    ]

    func updateBoardPosition(row: Int, column: Int, selection: BoardSpaceSelection) {
        assert(validateIndexAt(row: row, column: column), "Attempting to check board with index out of bounds...")

        boardArray[row][column] = selection

        checkForWinner()
    }

    func checkBoardPositionAt(row: Int, column: Int) -> BoardSpaceSelection? {
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
            [(0,0),(0,1),(0,2)],
            [(1,0),(1,1),(1,2)],
            [(2,0),(2,1),(2,2)],
            [(0,0),(1,0),(2,0)],
            [(0,1),(1,1),(2,1)],
            [(0,2),(1,2),(2,2)],
            [(0,0),(1,1),(2,2)],
            [(0,2),(1,1),(2,0)],
        ]

        for path in winningPaths {
            let set = Set(path.map { boardArray[$0][$1] })

            if set.count == 1, let selection = set.first, let selectionUnwrapped = selection {
                winningPlayer = {
                    switch selectionUnwrapped {
                    case .x:
                        return .x
                    case .o:
                        return .o
                    }
                }()

                showWinnerAlert = true

                break
            }
        }
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
}

struct BoardView: View {
    @ObservedObject private var gameEnvironment = GameEnvironment()

    var body: some View {
        VStack {
            Text("Current Player: \(gameEnvironment.currentPlayer.token)")
            BoardGridView(rows: 3, columns: 3, size: 100)
                .environmentObject(gameEnvironment)
        }.alert(isPresented: $gameEnvironment.showWinnerAlert) {
            Alert(title: Text("Game over!"), message: Text("Player \(gameEnvironment.winningPlayer?.token ?? "-") won the game!"), dismissButton: .default(Text("Done")))

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

    var body: some View {
        ZStack {
            Rectangle()
                .size(width: size, height: size)

            BoardSpaceButtonView(size: size, row: row, column: column)
        }
    }
}

struct BoardSpaceButtonView: View {
    let size: CGFloat
    let row: Int
    let column: Int

    @EnvironmentObject var gameEnvironment: GameEnvironment

    private var selection: BoardSpaceSelection? {
        gameEnvironment.checkBoardPositionAt(row: row, column: column)
    }

    var body: some View {
        switch selection {
        case .x, .o:
            Text(selection?.token ?? "")
                .font(.largeTitle)
                .frame(width: size, height: size)
        case .none:
            Button(action: {
                switch gameEnvironment.currentPlayer {
                case .x:
                    gameEnvironment.updateBoardPosition(row: row, column: column, selection: .x)
                    gameEnvironment.currentPlayer = .o
                case .o:
                    gameEnvironment.updateBoardPosition(row: row, column: column, selection: .o)
                    gameEnvironment.currentPlayer = .x
                }
            }, label: {
                Text("")
                    .frame(width: size, height: size)
            })
        }
    }
}

enum BoardSpaceSelection {
    case x
    case o

    var token: String {
        switch self {
        case .x:
            return PlayerType.x.token
        case .o:
            return PlayerType.o.token
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
