import Observation

@MainActor
@Observable
final class DashboardViewModel {
    var state: ViewState<[Course]> = .idle
    var isOffline = false

    let courseRepository: CourseRepository

    init(courseRepository: CourseRepository) {
        self.courseRepository = courseRepository
    }

    func loadCoursesIfNeeded() async {
        guard case .idle = state else { return }
        await loadCourses()
    }

    func loadCourses() async {
        if case .loaded = state {
            // Already showing data: keep the list mounted during a refresh so
            // .refreshable's own spinner can run without tearing down its control.
        } else {
            state = .loading
        }
        do {
            let courses = try await courseRepository.fetchCourses()
            isOffline = courseRepository.isUsingCachedData
            state = courses.isEmpty ? .empty : .loaded(courses)
        } catch is CancellationError {
            // Refresh was cancelled; leave whatever was already on screen alone.
        } catch {
            state = .failed(AppError.map(error))
        }
    }

    func updateCourse(_ course: Course) {
        guard case .loaded(var courses) = state,
              let index = courses.firstIndex(where: { $0.id == course.id }) else { return }
        courses[index] = course
        state = .loaded(courses)
    }
}
