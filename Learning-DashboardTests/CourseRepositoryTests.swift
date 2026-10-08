import Testing
@testable import Learning_Dashboard

@MainActor
struct CourseRepositoryTests {
    @Test func fetchCoursesFallsBackToCacheWhenAPIFails() async throws {
        let cachedLesson = LessonEntity(id: 1, title: "Lesson 1", isCompleted: true)
        let cachedCourse = CourseEntity(id: 1, title: "Python Programming", instructor: "John Smith", lessons: [cachedLesson])
        let store = InMemoryCourseStore(courses: [cachedCourse])
        let repository = CourseRepositoryImpl(api: FailingCourseAPI(), store: store)

        let courses = try await repository.fetchCourses()

        #expect(courses.count == 1)
        #expect(courses.first?.title == "Python Programming")
        #expect(repository.isUsingCachedData == true)
    }
}
