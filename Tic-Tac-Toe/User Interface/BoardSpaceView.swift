import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let selection: PlayerToken?
    var action: () -> Void = {}

    // MARK: - Private Properties

    private let size: CGFloat = 100
    private let backgroundColor: UIColor = .systemBackground

    // MARK: - Body

    var body: some View {
        Group {
            if let selection = selection {
                // Don't need to use Rectangle().foregroundColor(.systemBackground) here.
                // Can use .overlay(...) instead of ZStack.
                Color(backgroundColor)
                    .overlay(
                        Text(selection.token).font(.largeTitle)
                    )
            } else {
                // Can't use EmptyView() or Text("") here because the button won't have any size then.
                Button(action: action, label: { Color(backgroundColor) })
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
