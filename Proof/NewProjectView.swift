import SwiftUI
import SwiftData

struct NewProjectView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context

    @State private var name = ""
    @State private var details = ""
    @State private var technologies = ""
    @State private var startDate = Date.now

    var body: some View {
        NavigationStack {
            Form {
                Section("Project") {
                    TextField("Name", text: $name)
                    TextField("What are you building?", text: $details, axis: .vertical)
                    TextField("Technologies (e.g. SwiftUI, SwiftData)", text: $technologies)
                    DatePicker("Start date", selection: $startDate, displayedComponents: .date)
                }
            }
            .navigationTitle("New Project")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") {
                        let project = Project(
                            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
                            details: details,
                            technologies: technologies,
                            startDate: startDate
                        )
                        context.insert(project)
                        try? context.save()
                        dismiss()
                    }
                    .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
    }
}
