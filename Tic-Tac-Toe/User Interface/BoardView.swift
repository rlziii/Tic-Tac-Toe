import SwiftUI

struct BoardView: View {
    @State private var number: Int = 0

    private var numberString: String {
        String(number)
    }

    var body: some View {
        Text(numberString)
            .padding()
            .onAppear(perform: onAppear)
    }

    private func onAppear() {
        _ = Test.addListener(for: "C1yrH44aDDdrQ9JoL3zy") { result in
            switch result {
            case let .success(test):
                self.number = test.number
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }
}

struct BoardView_Previews: PreviewProvider {
    static var previews: some View {
        BoardView()
    }
}
