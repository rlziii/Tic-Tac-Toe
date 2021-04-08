import SwiftUI

struct ModeSelectView: View {

    // MARK: - Private Properties

    private var gridImage: some View {
        Image(systemName: "grid").font(.body)
    }

    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    HStack {
                        Spacer()
                        gridImage
                        Text("Tic-Tac-Toe")
                            .font(.largeTitle)
                        gridImage
                        Spacer()
                    }

                    NavigationLink(
                        destination: BoardView(isMultiplayer: false),
                        label: { Label("One Player", systemImage: "person.fill") }
                    )

                    NavigationLink(
                        destination: BoardView(isMultiplayer: true),
                        label: { Label("Two Player", systemImage: "person.2.fill") }
                    )
                }
            }
            .navigationBarTitle("Mode Select")
            .navigationBarHidden(true)
        }
    }
}

struct ModeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectView()
    }
}
