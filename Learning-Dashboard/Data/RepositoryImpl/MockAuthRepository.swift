import Foundation

final class MockAuthRepository: AuthRepository {
    func login(email: String, password: String) async throws -> User {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        guard email == DemoCredentials.email, password == DemoCredentials.password else {
            throw AppError.validation("Invalid email or password.")
        }
        return User(id: UUID().uuidString, email: email, token: UUID().uuidString)
    }
}
