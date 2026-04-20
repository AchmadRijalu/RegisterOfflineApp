//
//  ProfileRepository.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import Combine

protocol ProfileRepositoryProtocol {
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
}

final class ProfileRepository: ProfileRepositoryProtocol {
    typealias ProfileInstance = (ProfileRemoteDataSourceProtocol) -> ProfileRepository

    private let remoteDataSource: ProfileRemoteDataSourceProtocol

    private init(remote: ProfileRemoteDataSourceProtocol) {
        self.remoteDataSource = remote
    }

    static let sharedInstance: ProfileInstance = { remote in
        ProfileRepository(remote: remote)
    }

    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        remoteDataSource.getProfile()
    }
}
