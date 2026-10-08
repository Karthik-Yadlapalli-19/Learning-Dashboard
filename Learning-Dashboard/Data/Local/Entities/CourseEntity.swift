import SwiftData

@Model
final class CourseEntity {
    @Attribute(.unique) var id: Int
    var title: String
    var instructor: String
    @Relationship(deleteRule: .cascade) var lessons: [LessonEntity]

    init(id: Int, title: String, instructor: String, lessons: [LessonEntity]) {
        self.id = id
        self.title = title
        self.instructor = instructor
        self.lessons = lessons
    }
}
