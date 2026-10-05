import SwiftUI
import SwiftData

struct PortfolioView: View {
    @Query(sort: \Project.createdAt, order: .reverse) private var projects: [Project]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Your Portfolio")
                            .font(.largeTitle.bold())
                        Text("A snapshot of what you're building and learning.")
                            .foregroundStyle(.secondary)
                    }

                    if projects.isEmpty {
                        EmptyStateView()
                    } else {
                        ForEach(projects) { project in
                            VStack(alignment: .leading, spacing: 10) {
                                Text(project.name)
                                    .font(.title2.bold())
                                if !project.details.isEmpty {
                                    Text(project.details)
                                        .foregroundStyle(.secondary)
                                }
                                HStack {
                                    Label("\(Int(project.progress * 100))% complete", systemImage: "chart.bar.fill")
                                    Spacer()
                                    if !project.technologies.isEmpty {
                                        Text(project.technologies)
                                            .lineLimit(1)
                                    }
                                }
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                ProgressView(value: project.progress)
                            }
                            .padding()
                            .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Portfolio")
        }
    }
}
