import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let selection: PlayerToken?
    let action: () -> Void

    // MARK: - Body

    var body: some View {
        Group {
            if let selection = selection {
                // Don't need to use Rectangle().foregroundColor(.systemBackground) here.
                // Can use .overlay(...) instead of ZStack.
                Color(.systemBackground)
                    .overlay(
                        Text(selection.token)
                            .font(.largeTitle)
                            .scaleEffect(2.0)
                    )
            } else {
                // Can't use EmptyView() or Text("") here because the button won't have any size then.
                Button(action: action, label: { Color(.systemBackground) })
            }
        }.aspectRatio(1.0, contentMode: .fit)
    }
}

// MARK: - Previews

struct BoardSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            // Shows an empty space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .none, action: {})
                .border(Color.red)

            // Shows an ❌ space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .x, action: {})
                .border(Color.red)

            // Shows an ⭕️ space.
            // Red border is for visual debugging only.
            BoardSpaceView(selection: .o, action: {})
                .border(Color.red)
        }
    }
}
