import SwiftUI

struct BoardSpaceView: View {

    // MARK: - Public Properties

    let size: CGFloat
    let selection: PlayerToken?
    var action: () -> Void = {}

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
                Button(action: action, label: {
                    Text("")
                        .frame(width: size, height: size)
                })
            }
        }
    }
}

// MARK: - Previews

struct BoardSpaceView_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            // Shows an empty space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, selection: .none)
                .border(Color.red, width: 1)

            // Shows an ❌ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, selection: .x)
                .border(Color.red, width: 1)

            // Shows an ⭕️ space.
            // Red border is for visual debugging only.
            BoardSpaceView(size: 100, selection: .o)
                .border(Color.red, width: 1)
        }
    }
}
