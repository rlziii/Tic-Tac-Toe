import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let size: CGFloat
    let row: Int
    let column: Int

    // MARK: - Private Properties

    @EnvironmentObject private var game: Game

    private var selection: PlayerToken? {
        game.boardTokenFor(row: row, column: column)
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
                    game.updateBoardTokenFor(row: row, column: column)
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
    static let emptyGame = Game()

    static let xGame: Game = {
        let game = Game()
        game.updateBoardTokenFor(row: 0, column: 0)
        return game
    }()

    static let oGame: Game = {
        let game = Game()
        game.isMultiplayer = true
        game.updateBoardTokenFor(row: 0, column: 1)
        game.updateBoardTokenFor(row: 0, column: 0)
        return game
    }()

    static var previews: some View {
        HStack {
            // Shows an empty space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(emptyGame)

            // Shows an ❌ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(xGame)

            // Shows an ⭕️ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, row: 0, column: 0)
                .border(Color.red, width: 1)
                .environmentObject(oGame)
        }
    }
}
