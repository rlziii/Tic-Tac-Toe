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
                        destination: BoardView(mode: .onePlayer(.easy)),
                        label: { Label("One Player (Easy)", systemImage: "person.fill") }
                    )

                    NavigationLink(
                        destination: BoardView(mode: .onePlayer(.hard)),
                        label: { Label("One Player (Hard)", systemImage: "person.fill") }
                    )

                    NavigationLink(
                        destination: BoardView(mode: .twoPlayer),
                        label: { Label("Two Players", systemImage: "person.2.fill") }
                    )
                }
            }
            .navigationBarTitle("Mode Select")
        }
    }
}

struct ModeSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ModeSelectView()
    }
}
