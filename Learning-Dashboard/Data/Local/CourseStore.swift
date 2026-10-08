import SwiftData

protocol CourseStore {
    func fetchCourses() throws -> [CourseEntity]
    func upsert(_ courses: [CourseEntity]) throws
    func setLessonCompleted(courseId: Int, lessonId: Int, isCompleted: Bool) throws -> CourseEntity
}

final class SwiftDataCourseStore: CourseStore {
    private let modelContext: ModelContext

    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }

    func fetchCourses() throws -> [CourseEntity] {
        try modelContext.fetch(FetchDescriptor<CourseEntity>())
    }

    func upsert(_ courses: [CourseEntity]) throws {
        let existingById = Dictionary(uniqueKeysWithValues: try fetchCourses().map { ($0.id, $0) })

        for course in courses {
            if let match = existingById[course.id] {
                match.title = course.title
                match.instructor = course.instructor
            } else {
                modelContext.insert(course)
            }
        }
        try modelContext.save()
    }

    func setLessonCompleted(courseId: Int, lessonId: Int, isCompleted: Bool) throws -> CourseEntity {
        guard let course = try fetchCourses().first(where: { $0.id == courseId }) else {
            throw AppError.notFound
        }
        guard let lesson = course.lessons.first(where: { $0.id == lessonId }) else {
            throw AppError.notFound
        }
        lesson.isCompleted = isCompleted
        try modelContext.save()
        return course
    }
}
