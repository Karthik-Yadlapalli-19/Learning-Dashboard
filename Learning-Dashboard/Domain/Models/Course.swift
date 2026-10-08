struct Course: Identifiable, Equatable {
    let id: Int
    let title: String
    let instructor: String
    var lessons: [Lesson]

    var lessonCount: Int {
        lessons.count
    }

    var progress: Int {
        guard !lessons.isEmpty else { return 0 }
        let completedCount = lessons.filter(\.isCompleted).count
        return Int((Double(completedCount) / Double(lessons.count)) * 100)
    }
}
