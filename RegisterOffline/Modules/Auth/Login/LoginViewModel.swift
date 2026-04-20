//
//  LoginViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Combine

@MainActor
final class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var didLoginSuccess = false

    private let repository: LoginRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
    }
    
    var isLoginButtonEnabled: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty && !isLoading
    }

    func login() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedEmail.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }

        isLoading = true
        errorMessage = nil
        didLoginSuccess = false

        repository.login(email: trimmedEmail, password: password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] _ in
                self?.didLoginSuccess = true
            }
            .store(in: &cancellables)
    }

    func getSavedToken() -> String? {
        repository.getToken()
    }

    func logout() {
        repository.logout()
        didLoginSuccess = false
    }
}
