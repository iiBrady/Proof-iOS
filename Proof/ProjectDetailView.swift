import SwiftUI
import SwiftData

struct ProjectDetailView: View {
    @Environment(\.modelContext) private var context
    @Bindable var project: Project

    @State private var milestoneText = ""
    @State private var activityText = ""

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    Text(project.name)
                        .font(.title.bold())
                    if !project.details.isEmpty {
                        Text(project.details)
                            .foregroundStyle(.secondary)
                    }
                    ProgressView(value: project.progress)
                    Text("\(project.completedMilestones) of \(project.milestones.count) milestones complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 8)
            }

            Section("Milestones") {
                HStack {
                    TextField("Add milestone", text: $milestoneText)
                    Button {
                        addMilestone()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(milestoneText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                ForEach(project.milestones.sorted(by: { $0.createdAt < $1.createdAt })) { milestone in
                    Button {
                        milestone.isComplete.toggle()
                        try? context.save()
                    } label: {
                        HStack {
                            Image(systemName: milestone.isComplete ? "checkmark.circle.fill" : "circle")
                            Text(milestone.title)
                                .strikethrough(milestone.isComplete)
                            Spacer()
                        }
                        .foregroundStyle(.primary)
                    }
                }
                .onDelete { offsets in
                    let sorted = project.milestones.sorted(by: { $0.createdAt < $1.createdAt })
                    for index in offsets {
                        context.delete(sorted[index])
                    }
                    try? context.save()
                }
            }

            Section("Log an accomplishment") {
                HStack {
                    TextField("What did you accomplish?", text: $activityText)
                    Button {
                        addActivity()
                    } label: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .disabled(activityText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }

                ForEach(project.activities.sorted(by: { $0.date > $1.date })) { activity in
                    ActivityRow(activity: activity)
                }
            }

            if !project.technologies.isEmpty {
                Section("Built with") {
                    Text(project.technologies)
                }
            }
        }
        .navigationTitle("Project")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func addMilestone() {
        let text = milestoneText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        let milestone = Milestone(title: text, project: project)
        context.insert(milestone)
        milestoneText = ""
        try? context.save()
    }

    private func addActivity() {
        let text = activityText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        let activity = Activity(text: text, project: project)
        context.insert(activity)
        activityText = ""
        try? context.save()
    }
}
