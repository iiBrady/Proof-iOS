import Foundation
import SwiftData

@Model
final class Project {
    var name: String
    var details: String
    var technologies: String
    var startDate: Date
    var createdAt: Date

    @Relationship(deleteRule: .cascade, inverse: \Milestone.project)
    var milestones: [Milestone] = []

    @Relationship(deleteRule: .cascade, inverse: \Activity.project)
    var activities: [Activity] = []

    init(name: String, details: String = "", technologies: String = "", startDate: Date = .now) {
        self.name = name
        self.details = details
        self.technologies = technologies
        self.startDate = startDate
        self.createdAt = .now
    }

    var completedMilestones: Int {
        milestones.filter(\.isComplete).count
    }

    var progress: Double {
        guard !milestones.isEmpty else { return 0 }
        return Double(completedMilestones) / Double(milestones.count)
    }
}

@Model
final class Milestone {
    var title: String
    var isComplete: Bool
    var createdAt: Date
    var project: Project?

    init(title: String, project: Project? = nil) {
        self.title = title
        self.isComplete = false
        self.createdAt = .now
        self.project = project
    }
}

@Model
final class Activity {
    var text: String
    var date: Date
    var project: Project?

    init(text: String, date: Date = .now, project: Project? = nil) {
        self.text = text
        self.date = date
        self.project = project
    }
}
