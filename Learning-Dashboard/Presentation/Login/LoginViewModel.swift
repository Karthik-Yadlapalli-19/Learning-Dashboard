import Observation

@MainActor
@Observable
final class LoginViewModel {
    var email = ""
    var password = ""
    var state: ViewState<User> = .idle

    let demoEmail = DemoCredentials.email
    let demoPassword = DemoCredentials.password

    private let authRepository: AuthRepository = MockAuthRepository()

    var emailError: String? {
        guard !email.isEmpty, !Validators.isValidEmail(email) else { return nil }
        return "Enter a valid email address."
    }

    var passwordError: String? {
        guard !password.isEmpty, !Validators.isValidPassword(password) else { return nil }
        return "Password must be at least 6 characters."
    }

    var isFormValid: Bool {
        Validators.isValidEmail(email) && Validators.isValidPassword(password)
    }

    var isLoading: Bool {
        if case .loading = state { return true }
        return false
    }

    func login() async {
        guard isFormValid else {
            state = .failed(.validation("Please enter a valid email and password."))
            return
        }
        state = .loading
        do {
            let user = try await authRepository.login(email: email, password: password)
            state = .loaded(user)
        } catch {
            state = .failed(AppError.map(error))
        }
    }
}
