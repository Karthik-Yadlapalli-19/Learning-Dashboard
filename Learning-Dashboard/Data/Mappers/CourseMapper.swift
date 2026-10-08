enum CourseMapper {
    static func entity(from dto: CourseDTO) -> CourseEntity {
        guard dto.lessons > 0 else {
            return CourseEntity(id: dto.id, title: dto.title, instructor: dto.instructor, lessons: [])
        }
        let completedCount = Int((Double(dto.progress) / 100.0) * Double(dto.lessons))
        let lessons = (1...dto.lessons).map { index in
            LessonEntity(id: index, title: "Lesson \(index)", isCompleted: index <= completedCount)
        }
        return CourseEntity(id: dto.id, title: dto.title, instructor: dto.instructor, lessons: lessons)
    }

    static func domain(from entity: CourseEntity) -> Course {
        let lessons = entity.lessons
            .sorted { $0.id < $1.id }
            .map { Lesson(id: $0.id, title: $0.title, isCompleted: $0.isCompleted) }
        return Course(id: entity.id, title: entity.title, instructor: entity.instructor, lessons: lessons)
    }
}
