protocol CourseRepository {
    var isUsingCachedData: Bool { get }
    func fetchCourses() async throws -> [Course]
    func setLessonCompleted(courseId: Int, lessonId: Int, isCompleted: Bool) async throws -> Course
}
