import SwiftUI

struct LoginView: View {
    @Environment(AppContainer.self) private var container
    @State private var viewModel = LoginViewModel()
    @State private var showingCredentialsHint = false

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 44))
                        .foregroundStyle(Color.accentColor)
                    Text("Learning Dashboard")
                        .font(.title.bold())
                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 32)

                VStack(spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        fieldContainer {
                            Image(systemName: "envelope")
                                .foregroundStyle(.secondary)
                                .frame(width: 20)
                            TextField("Email", text: $viewModel.email)
                                .textContentType(.emailAddress)
                                .keyboardType(.emailAddress)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                        }
                        if let emailError = viewModel.emailError {
                            Text(emailError)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.leading, 4)
                        }
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        fieldContainer {
                            Image(systemName: "lock")
                                .foregroundStyle(.secondary)
                                .frame(width: 20)
                            SecureField("Password", text: $viewModel.password)
                                .textContentType(.password)
                        }
                        if let passwordError = viewModel.passwordError {
                            Text(passwordError)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .padding(.leading, 4)
                        }
                    }
                }

                if case .failed(let error) = viewModel.state {
                    Text(error.userMessage)
                        .font(.caption)
                        .foregroundStyle(.red)
                }

                Button {
                    Task {
                        await viewModel.login()
                        if case .loaded(let user) = viewModel.state {
                            container.login(user)
                        }
                    }
                } label: {
                    Group {
                        if viewModel.isLoading {
                            ProgressView()
                                .tint(.white)
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 6)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .disabled(!viewModel.isFormValid || viewModel.isLoading)

                Spacer()
            }
            .padding(.horizontal, 24)

            Button {
                showingCredentialsHint = true
            } label: {
                Image(systemName: "questionmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(.secondary)
            }
            .padding()
            .popover(isPresented: $showingCredentialsHint) {
                DemoCredentialsHintView(email: viewModel.demoEmail, password: viewModel.demoPassword)
            }
        }
    }

    @ViewBuilder
    private func fieldContainer<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        HStack(spacing: 12) {
            content()
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }
}

private struct DemoCredentialsHintView: View {
    let email: String
    let password: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Demo Credentials")
                .font(.headline)
            VStack(alignment: .leading, spacing: 4) {
                Text("Email").font(.caption).foregroundStyle(.secondary)
                Text(email).font(.body.monospaced())
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Password").font(.caption).foregroundStyle(.secondary)
                Text(password).font(.body.monospaced())
            }
        }
        .padding()
        .frame(minWidth: 240)
        .presentationCompactAdaptation(.popover)
    }
}
