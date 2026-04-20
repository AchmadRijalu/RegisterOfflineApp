//
//  RegisterViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Combine

@MainActor
final class RegisterViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var fullName = ""
    @Published var phone = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var successMessage: String?
    @Published var didRegisterSuccess = false

    private let repository: RegisterRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()

    init(repository: RegisterRepositoryProtocol) {
        self.repository = repository
    }

    var isRegisterButtonEnabled: Bool {
        !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !password.isEmpty &&
        !fullName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !isLoading
    }

    func register() {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPhone = phone.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmedEmail.isEmpty, !password.isEmpty, !trimmedFullName.isEmpty else {
            errorMessage = "Email, password, and full name are required."
            return
        }

        isLoading = true
        errorMessage = nil
        successMessage = nil
        didRegisterSuccess = false

        repository.register(
            email: trimmedEmail,
            password: password,
            fullName: trimmedFullName,
            phone: trimmedPhone.isEmpty ? nil : trimmedPhone
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] completion in
            guard let self else { return }
            self.isLoading = false

            if case let .failure(error) = completion {
                self.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] message in
            self?.successMessage = message
            self?.didRegisterSuccess = true
        }
        .store(in: &cancellables)
    }
}
