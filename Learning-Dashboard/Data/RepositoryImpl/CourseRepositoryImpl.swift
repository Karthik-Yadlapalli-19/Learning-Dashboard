final class CourseRepositoryImpl: CourseRepository {
    private(set) var isUsingCachedData = false

    private let api: CourseAPI
    private let store: CourseStore

    init(api: CourseAPI, store: CourseStore) {
        self.api = api
        self.store = store
    }

    func fetchCourses() async throws -> [Course] {
        do {
            let dtos = try await api.fetchCourses()
            let entities = dtos.map(CourseMapper.entity(from:))
            try store.upsert(entities)
            isUsingCachedData = false
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            let cached = try store.fetchCourses()
            if cached.isEmpty {
                throw AppError.map(error)
            }
            isUsingCachedData = true
        }
        return try store.fetchCourses().map(CourseMapper.domain(from:))
    }

    func setLessonCompleted(courseId: Int, lessonId: Int, isCompleted: Bool) async throws -> Course {
        let entity = try store.setLessonCompleted(courseId: courseId, lessonId: lessonId, isCompleted: isCompleted)
        return CourseMapper.domain(from: entity)
    }
}
