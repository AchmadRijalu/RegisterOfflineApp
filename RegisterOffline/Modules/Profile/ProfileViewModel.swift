//
//  ProfileViewModel.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import Foundation
import Combine

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var fullName = "-"
    @Published var email = "-"
    @Published var address = "Menteng, Jakarta Pusat, DKI Jakarta"
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let repository: ProfileRepositoryProtocol
    private var cancellables = Set<AnyCancellable>()
    private var hasLoadedProfile = false

    init(repository: ProfileRepositoryProtocol) {
        self.repository = repository
    }

    func loadProfileIfNeeded() {
        guard !hasLoadedProfile else { return }
        loadProfile()
    }

    func loadProfile() {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        repository.getProfile()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false

                if case let .failure(error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] profileResponse in
                guard let self else { return }
                let profile = ProfileModel(
                    id: profileResponse.id ?? "-",
                    fullName: profileResponse.fullName ?? "-",
                    email: profileResponse.email ?? "-",
                    address: profileResponse.address
                )
                self.fullName = profile.fullName
                self.email = profile.email
                self.address = profile.address ?? "-"
                self.hasLoadedProfile = true
            }
            .store(in: &cancellables)
    }
}
