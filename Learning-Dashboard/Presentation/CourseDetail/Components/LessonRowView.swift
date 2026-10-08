import SwiftUI

struct LessonRowView: View {
    let lesson: Lesson
    let onToggle: () -> Void

    var body: some View {
        Button(action: onToggle) {
            HStack {
                Text(lesson.title)
                    .foregroundStyle(.primary)
                Spacer()
                if lesson.isCompleted {
                    Label("Completed", systemImage: "checkmark.circle.fill")
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(.green)
                } else {
                    Label("Pending", systemImage: "circle")
                        .labelStyle(.titleAndIcon)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .buttonStyle(.plain)
    }
}
