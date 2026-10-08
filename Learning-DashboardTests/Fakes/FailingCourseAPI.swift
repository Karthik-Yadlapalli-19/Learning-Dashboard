import Foundation
@testable import Learning_Dashboard

struct FailingCourseAPI: CourseAPI {
    func fetchCourses() async throws -> [CourseDTO] {
        throw URLError(.notConnectedToInternet)
    }
}
