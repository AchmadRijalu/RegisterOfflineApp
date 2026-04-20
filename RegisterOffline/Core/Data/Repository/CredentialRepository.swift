//
//  CredentialRepository.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 16/04/26.
//

import Foundation
import KeychainSwift

protocol CredentialRepositoryProtocol {
    func saveToken(_ token: String)
    func getToken() -> String?
    func deleteToken()
}

final class CredentialRepository: CredentialRepositoryProtocol {
    private let keychain = KeychainSwift()
    private let tokenKey = "userToken"

    func saveToken(_ token: String) {
        keychain.set(token, forKey: tokenKey)
    }

    func getToken() -> String? {
        keychain.get(tokenKey)
    }

    func deleteToken() {
        keychain.delete(tokenKey)
    }
}
