import SwiftUI

struct CourseRowView: View {
    let course: Course

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(course.title)
                .font(.headline)
            Text(course.instructor)
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack {
                ProgressView(value: Double(course.progress), total: 100)
                Text("\(course.progress)%")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            HStack {
                Text("\(course.lessonCount) lessons")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Spacer()
                Text("Continue")
                    .font(.caption.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Capsule().fill(Color.accentColor.opacity(0.15)))
                    .foregroundStyle(Color.accentColor)
            }
        }
        .padding(.vertical, 4)
    }
}
