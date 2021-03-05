import SwiftUI

@main
struct Application: App {

    // MARK: - Private Properties

    @StateObject private var gameEnvironment = GameEnvironment()

    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            ModeSelectView()
                .environmentObject(gameEnvironment)
        }
    }
}
