import SwiftUI
import SwiftData

@main
struct Learning_DashboardApp: App {
    private let sharedModelContainer: ModelContainer
    private let container: AppContainer

    init() {
        let schema = Schema([
            CourseEntity.self,
            LessonEntity.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            sharedModelContainer = try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }

        container = AppContainer(modelContext: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(container)
        }
        .modelContainer(sharedModelContainer)
    }
}
