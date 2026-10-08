struct CourseDTO: Decodable {
    let id: Int
    let title: String
    let instructor: String
    let progress: Int
    let lessons: Int
}
