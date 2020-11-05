import SwiftUI

@main
struct Application: App {
    private let firebaseManager = FirebaseManager()

    var body: some Scene {
        WindowGroup {
            BoardView()
        }
    }
}
