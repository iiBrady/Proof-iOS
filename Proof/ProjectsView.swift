import SwiftUI
import SwiftData

struct ProjectsView: View {
    @Query(sort: \Project.createdAt, order: .reverse) private var projects: [Project]
    @State private var showingNewProject = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(projects) { project in
                    NavigationLink {
                        ProjectDetailView(project: project)
                    } label: {
                        ProjectRow(project: project)
                    }
                }
                .onDelete { offsets in
                    // SwiftData deletion is handled in the view model context below.
                }
            }
            .overlay {
                if projects.isEmpty {
                    EmptyStateView()
                }
            }
            .navigationTitle("Projects")
            .toolbar {
                Button {
                    showingNewProject = true
                } label: {
                    Image(systemName: "plus")
                }
            }
            .sheet(isPresented: $showingNewProject) {
                NewProjectView()
            }
        }
    }
}

struct ProjectRow: View {
    let project: Project

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text(project.name)
                    .font(.headline)
                Spacer()
                Text("\(Int(project.progress * 100))%")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ProgressView(value: project.progress)

            if !project.technologies.isEmpty {
                Text(project.technologies)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(.vertical, 5)
    }
}

struct ActivityRow: View {
    let activity: Activity

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(.secondary)
            VStack(alignment: .leading, spacing: 3) {
                Text(activity.text)
                Text(activity.date, style: .date)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
