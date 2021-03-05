import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let size: CGFloat
    let row: Int
    let column: Int

    // MARK: - Private Properties

    @EnvironmentObject private var gameEnvironment: GameEnvironment

    private var selection: PlayerToken? {
        gameEnvironment.boardTokenFor(row: row, column: column)
    }

    // MARK: - Body

    var body: some View {
        ZStack {
            Rectangle()
                .size(width: size, height: size)
                .frame(width: size, height: size)
                .foregroundColor(Color(.systemBackground))

            switch selection {
            case .x, .o:
                Text(selection?.token ?? "")
                    .font(.largeTitle)
                    .frame(width: size, height: size)
            case .none:
                Button(action: {
                    gameEnvironment.updateBoardTokenFor(row: row, column: column)
                }, label: {
                    Text("")
                        .frame(width: size, height: size)
                })
            }
        }
    }
}

// MARK: - Previews

struct BoardSpaceView_Previews: PreviewProvider {
    static let emptyGameEnvironment = GameEnvironment()

    static let xGameEnvironment: GameEnvironment = {
        let gameEnvironment = GameEnvironment()
        gameEnvironment.updateBoardTokenFor(row: 0, column: 0)
        return gameEnvironment
    }()

    static let oGameEnvironment: GameEnvironment = {
        let gameEnvironment = GameEnvironment()
        gameEnvironment.isMultiplayer = true
        gameEnvironment.updateBoardTokenFor(row: 0, column: 1)
        gameEnvironment.updateBoardTokenFor(row: 0, column: 0)
        return gameEnvironment
    }()

    static var previews: some View {
        HStack {
            // Shows an empty space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(emptyGameEnvironment)

            // Shows an ❌ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(xGameEnvironment)

            // Shows an ⭕️ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(oGameEnvironment)
        }
    }
}
