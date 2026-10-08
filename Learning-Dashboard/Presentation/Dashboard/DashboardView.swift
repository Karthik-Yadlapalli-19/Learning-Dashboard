import SwiftUI

struct DashboardView: View {
    let viewModel: DashboardViewModel

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                if viewModel.isOffline {
                    OfflineBannerView()
                }
                content
            }
            .navigationTitle("My Courses")
            .task {
                await viewModel.loadCoursesIfNeeded()
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle, .loading:
            LoadingView()
        case .loaded(let courses):
            List(courses) { course in
                NavigationLink {
                    CourseDetailView(
                        viewModel: CourseDetailViewModel(
                            course: course,
                            courseRepository: viewModel.courseRepository,
                            onCourseUpdated: viewModel.updateCourse
                        )
                    )
                } label: {
                    CourseRowView(course: course)
                }
            }
            .listStyle(.plain)
            .refreshable {
                await viewModel.loadCourses()
            }
        case .empty:
            EmptyStateView(message: "No courses yet.")
        case .failed(let error):
            ErrorView(message: error.userMessage) {
                Task { await viewModel.loadCourses() }
            }
        }
    }
}

private struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct ErrorView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundStyle(.orange)
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
            Button("Retry", action: retryAction)
                .buttonStyle(.bordered)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

private struct EmptyStateView: View {
    let message: String

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(message)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
