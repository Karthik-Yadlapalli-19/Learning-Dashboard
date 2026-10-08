@testable import Learning_Dashboard

final class InMemoryCourseStore: CourseStore {
    private var courses: [CourseEntity]

    init(courses: [CourseEntity] = []) {
        self.courses = courses
    }

    func fetchCourses() throws -> [CourseEntity] {
        courses
    }

    func upsert(_ courses: [CourseEntity]) throws {
        for course in courses {
            if let index = self.courses.firstIndex(where: { $0.id == course.id }) {
                self.courses[index] = course
            } else {
                self.courses.append(course)
            }
        }
    }

    func setLessonCompleted(courseId: Int, lessonId: Int, isCompleted: Bool) throws -> CourseEntity {
        guard let course = courses.first(where: { $0.id == courseId }) else {
            throw AppError.notFound
        }
        guard let lesson = course.lessons.first(where: { $0.id == lessonId }) else {
            throw AppError.notFound
        }
        lesson.isCompleted = isCompleted
        return course
    }
}
