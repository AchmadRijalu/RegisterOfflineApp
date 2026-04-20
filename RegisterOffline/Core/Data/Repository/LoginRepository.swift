//
//  LoginRepository.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 16/04/26.
//

import Foundation
import Combine

protocol LoginRepositoryProtocol {
    func login(email: String, password: String) -> AnyPublisher<String, Error>
    func getToken() -> String?
    func logout()
}

final class LoginRepository: LoginRepositoryProtocol {

    typealias LoginInstance = (LoginRemoteDataSourceProtocol) -> LoginRepository

    private let remoteDataSource: LoginRemoteDataSourceProtocol

    private init(remote: LoginRemoteDataSourceProtocol) {
        self.remoteDataSource = remote
    }

    static let sharedInstance: LoginInstance = { remote in
        return LoginRepository(remote: remote)
    }

    func login(email: String, password: String) -> AnyPublisher<String, Error> {
        remoteDataSource.login(email: email, password: password)
    }

    func getToken() -> String? {
        remoteDataSource.getToken()
    }

    func logout() {
        remoteDataSource.logout()
    }
}
