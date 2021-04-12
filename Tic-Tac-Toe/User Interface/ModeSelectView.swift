import SwiftUI

struct ModeSelectView: View {

    // MARK: - Body
    
    var body: some View {
        NavigationView {
            Form {
                HStack {
                    Spacer()
                    Image(systemName: "grid")
                    Text("Tic-Tac-Toe").font(.largeTitle)
                    Image(systemName: "grid")
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
