import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let selection: PlayerToken?
    var action: () -> Void = {}

    // MARK: - Private Properties

    private let size: CGFloat = 100

    // MARK: - Body

    var body: some View {
        ZStack {
            // Don't even need Rectangle.foregroundColor(...) here...
            Color(.systemBackground)

            switch selection {
            case .x, .o:
                Text(selection?.token ?? "")
                    .font(.largeTitle)
            case .none:
                Button(action: action, label: {
                    Color(.systemBackground)
                })
            }
        }.frame(width: size, height: size)
    }
}

// MARK: - Previews

struct BoardSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            // Shows an empty space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .none)
                .border(Color.red, width: 1)

            // Shows an ❌ space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .x)
                .border(Color.red, width: 1)

            // Shows an ⭕️ space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .o)
                .border(Color.red, width: 1)
        }
    }
}
