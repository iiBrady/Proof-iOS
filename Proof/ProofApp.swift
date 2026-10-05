import SwiftUI
import SwiftData

@main
struct ProofApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [Project.self, Milestone.self, Activity.self])
    }
}
