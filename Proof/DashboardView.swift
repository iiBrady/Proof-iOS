import SwiftUI
import SwiftData

struct DashboardView: View {
    @Query(sort: \Project.createdAt, order: .reverse) private var projects: [Project]
    @Query(sort: \Activity.date, order: .reverse) private var activities: [Activity]
    @State private var showingNewProject = false

    private var completed: Int {
        projects.reduce(0) { $0 + $1.completedMilestones }
    }

    private var total: Int {
        projects.reduce(0) { $0 + $1.milestones.count }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Good work.")
                            .font(.largeTitle.bold())
                        Text("Keep building proof of what you can do.")
                            .foregroundStyle(.secondary)
                    }

                    HStack(spacing: 12) {
                        StatCard(title: "Projects", value: "\(projects.count)", icon: "folder")
                        StatCard(title: "Milestones", value: "\(completed)/\(total)", icon: "checkmark.circle")
                    }

                    Button {
                        showingNewProject = true
                    } label: {
                        Label("New Project", systemImage: "plus")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.primary, in: RoundedRectangle(cornerRadius: 16))
                            .foregroundStyle(.background)
                    }

                    if !projects.isEmpty {
                        Text("Your projects")
                            .font(.title2.bold())

                        ForEach(projects.prefix(3)) { project in
                            NavigationLink {
                                ProjectDetailView(project: project)
                            } label: {
                                ProjectRow(project: project)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    if !activities.isEmpty {
                        Text("Recent activity")
                            .font(.title2.bold())

                        ForEach(activities.prefix(5)) { activity in
                            ActivityRow(activity: activity)
                        }
                    }

                    if projects.isEmpty {
                        EmptyStateView()
                    }
                }
                .padding()
            }
            .navigationTitle("Proof")
            .sheet(isPresented: $showingNewProject) {
                NewProjectView()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
            Text(value)
                .font(.title.bold())
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 18))
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
            Text("Start your first project")
                .font(.headline)
            Text("Build something real, track the work, and turn it into proof.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
    }
}
