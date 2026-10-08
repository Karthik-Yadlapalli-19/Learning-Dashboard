import Foundation

protocol CourseAPI {
    func fetchCourses() async throws -> [CourseDTO]
}

struct BundledCourseAPI: CourseAPI {
    func fetchCourses() async throws -> [CourseDTO] {
        try await Task.sleep(nanoseconds: 500_000_000)
        guard let url = Bundle.main.url(forResource: "courses", withExtension: "json") else {
            throw AppError.notFound
        }
        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode([CourseDTO].self, from: data)
    }
}
