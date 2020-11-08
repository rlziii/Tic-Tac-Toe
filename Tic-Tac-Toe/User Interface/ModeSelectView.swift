import SwiftUI

struct ModeSelectView: View {
    var body: some View {
        NavigationView {
            VStack {
                Spacer()

                Text("Tic-Tac-Toe")
                    .font(.largeTitle)

                Spacer()

                NavigationLink("👤 Single Player", destination: BoardView(isMultiplayer: false))
                    .padding()

                NavigationLink("👥 Local Two Player", destination: BoardView(isMultiplayer: true))
                    .padding()

                NavigationLink(
                    destination: BoardView(isMultiplayer: true),
                    isActive: .constant(false),
                    label: {
                        Text("🌎 Network Two Player").foregroundColor(.gray)
                    })
                    .padding()

                Spacer()
            }.navigationBarTitle("Mode Select")
            .navigationBarHidden(true)
        }
    }
}

struct ModeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectView()
    }
}
