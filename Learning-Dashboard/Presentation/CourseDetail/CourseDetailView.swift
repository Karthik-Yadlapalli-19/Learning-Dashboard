import SwiftUI

struct CourseDetailView: View {
    let viewModel: CourseDetailViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(viewModel.course.title)
                    .font(.title2.bold())
                Text(viewModel.course.instructor)
                    .foregroundStyle(.secondary)
                ProgressView(value: Double(viewModel.course.progress), total: 100)
                Text("\(viewModel.course.progress)% complete")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .padding(.horizontal)
            }

            List(viewModel.course.lessons) { lesson in
                LessonRowView(lesson: lesson) {
                    Task { await viewModel.toggleLesson(lesson) }
                }
            }
            .listStyle(.plain)
        }
        .navigationTitle("Course Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
