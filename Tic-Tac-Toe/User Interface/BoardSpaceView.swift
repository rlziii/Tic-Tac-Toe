import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let size: CGFloat
    let row: Int
    let column: Int

    // MARK: - Private Properties

    @EnvironmentObject private var gameEnvironment: GameEnvironment

    private var selection: PlayerToken? {
        gameEnvironment.checkBoardPositionAt(row: row, column: column)
    }

    // MARK: - Body

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
