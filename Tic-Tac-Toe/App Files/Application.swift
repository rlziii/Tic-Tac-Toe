import SwiftUI

@main
struct Application: App {

    // MARK: - Private Properties

    @StateObject private var gameEnvironment = GameEnvironment()
    private let firebaseManager = FirebaseManager()

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ModeSelectView()
                .environmentObject(gameEnvironment)
        }
    }
}
