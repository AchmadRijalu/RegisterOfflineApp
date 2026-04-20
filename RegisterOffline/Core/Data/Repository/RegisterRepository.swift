//
//  RegisterRepository.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Combine

protocol RegisterRepositoryProtocol {
    func register(email: String, password: String, fullName: String, phone: String?) -> AnyPublisher<String, Error>
}

final class RegisterRepository: RegisterRepositoryProtocol {
    typealias RegisterInstance = (RegisterRemoteDataSourceProtocol) -> RegisterRepository

    private let remoteDataSource: RegisterRemoteDataSourceProtocol

    private init(remote: RegisterRemoteDataSourceProtocol) {
        self.remoteDataSource = remote
    }

    static let sharedInstance: RegisterInstance = { remote in
        RegisterRepository(remote: remote)
    }

    func register(email: String, password: String, fullName: String, phone: String?) -> AnyPublisher<String, Error> {
        remoteDataSource.register(email: email, password: password, fullName: fullName, phone: phone)
    }
}
