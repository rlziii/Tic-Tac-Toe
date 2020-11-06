import SwiftUI

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
    @State private var currentPlayer: PlayerType = .x

    var body: some View {
        VStack {
            Text("Current Player: \(currentPlayer.token)")
            BoardGridView(rows: 3, columns: 3, size: 100, currentPlayer: $currentPlayer)
        }
    }
}

struct BoardGridView: View {
    let rows: Int
    let columns: Int
    let size: CGFloat

    @Binding var currentPlayer: PlayerType

    private var rowsRange: ClosedRange<Int> {
        0...(rows - 1)
    }

    private var columnsRange: ClosedRange<Int> {
        0...(columns - 1)
    }

    var body: some View {
        HStack {
            ForEach(rowsRange, id: \.self) { a in
                VStack {
                    ForEach(columnsRange, id: \.self) { _ in
                        BoardSpaceView(size: size, currentPlayer: $currentPlayer)
                            .frame(width: size, height: size)
                    }
                }
            }
        }
    }
}

struct BoardSpaceView: View {
    let size: CGFloat

    @Binding var currentPlayer: PlayerType

    @State private var selection: BoardSpaceSelection = .none

    var body: some View {
        ZStack {
            Rectangle()
                .size(width: size, height: size)

            BoardSpaceButtonView(size: size, selection: $selection, currentPlayer: $currentPlayer)
        }
    }
}

struct BoardSpaceButtonView: View {
    let size: CGFloat

    @Binding var selection: BoardSpaceSelection
    @Binding var currentPlayer: PlayerType

    var body: some View {
        Button(action: {
            switch selection {
            case .x, .o:
                break // Do nothing
            case .none:
                switch currentPlayer {
                case .x:
                    selection = .x
                    currentPlayer = .o
                case .o:
                    selection = .o
                    currentPlayer = .x
                }
            }
        }, label: {
            Text(selection.token)
                .font(.largeTitle)
                .frame(width: size, height: size)
        })
    }
}

enum BoardSpaceSelection {
    case x
    case o
    case none

    var token: String {
        switch self {
        case .x:
            return PlayerType.x.token
        case .o:
            return PlayerType.o.token
        case .none:
            return ""
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
