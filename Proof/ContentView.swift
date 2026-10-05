import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem { Label("Home", systemImage: "house.fill") }
                .tag(0)

            ProjectsView()
                .tabItem { Label("Projects", systemImage: "folder.fill") }
                .tag(1)

            PortfolioView()
                .tabItem { Label("Portfolio", systemImage: "person.crop.square") }
                .tag(2)
        }
        .tint(.primary)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Project.self, Milestone.self, Activity.self], inMemory: true)
}
