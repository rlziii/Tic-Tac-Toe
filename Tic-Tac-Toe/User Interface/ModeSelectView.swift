import SwiftUI

struct ModeSelectView: View {

    let gridImage: some View = Image(systemName: "grid").font(.body)
    let singlePlayerImage = Image(systemName: "person.fill")
    let multiPlayerImage = Image(systemName: "person.2.fill")

    // MARK: - Body
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    gridImage
                    Text("Tic-Tac-Toe").font(.largeTitle)
                    gridImage
                }.padding()

                NavigationLink(
                    "\(singlePlayerImage) Single Player",
                    destination: BoardView(isMultiplayer: false)
                ).padding(.top)

                NavigationLink(
                    "\(multiPlayerImage) Local Two Player",
                    destination: BoardView(isMultiplayer: true)
                ).padding()
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
