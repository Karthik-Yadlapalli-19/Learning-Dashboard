import Observation

@MainActor
@Observable
final class CourseDetailViewModel {
    var course: Course
    var errorMessage: String?

    private let courseRepository: CourseRepository
    private let onCourseUpdated: (Course) -> Void

    init(course: Course, courseRepository: CourseRepository, onCourseUpdated: @escaping (Course) -> Void) {
        self.course = course
        self.courseRepository = courseRepository
        self.onCourseUpdated = onCourseUpdated
    }

    func toggleLesson(_ lesson: Lesson) async {
        do {
            let updated = try await courseRepository.setLessonCompleted(
                courseId: course.id,
                lessonId: lesson.id,
                isCompleted: !lesson.isCompleted
            )
            course = updated
            onCourseUpdated(updated)
        } catch {
            errorMessage = AppError.map(error).userMessage
        }
    }
}
