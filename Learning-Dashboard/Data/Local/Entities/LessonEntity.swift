import SwiftData

@Model
final class LessonEntity {
    var id: Int
    var title: String
    var isCompleted: Bool

    init(id: Int, title: String, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
    }
}
