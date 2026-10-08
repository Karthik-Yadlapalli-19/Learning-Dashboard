import SwiftData
import Observation
import Foundation

@MainActor
@Observable
final class AppContainer {
    private static let isLoggedInKey = "isLoggedIn"

    let courseRepository: CourseRepository

    private let defaults: UserDefaults

    var isLoggedIn: Bool

    init(modelContext: ModelContext, defaults: UserDefaults = .standard) {
        self.defaults = defaults
        courseRepository = CourseRepositoryImpl(
            api: BundledCourseAPI(),
            store: SwiftDataCourseStore(modelContext: modelContext)
        )
        isLoggedIn = defaults.bool(forKey: Self.isLoggedInKey)
    }

    func login(_ user: User) {
        isLoggedIn = true
        defaults.set(true, forKey: Self.isLoggedInKey)
    }

    func logout() {
        isLoggedIn = false
        defaults.set(false, forKey: Self.isLoggedInKey)
    }
}
