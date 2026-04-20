//
//  ProfileRemoteDataSource.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

protocol ProfileRemoteDataSourceProtocol: AnyObject {
    func getProfile() -> AnyPublisher<ProfileResponse, Error>
}

final class ProfileRemoteDataSource: NSObject {
    private let keychainRepository: CredentialRepositoryProtocol

    static func sharedInstance(_ keychainRepository: CredentialRepositoryProtocol) -> ProfileRemoteDataSource {
        ProfileRemoteDataSource(keychainRepository: keychainRepository)
    }

    private init(keychainRepository: CredentialRepositoryProtocol) {
        self.keychainRepository = keychainRepository
        super.init()
    }
}

extension ProfileRemoteDataSource: ProfileRemoteDataSourceProtocol {
    func getProfile() -> AnyPublisher<ProfileResponse, Error> {
        let endpoint = Endpoints.Gets.profile
        let url = endpoint.url
        let headers = APICall.makeHeaders(
            bearerToken: keychainRepository.getToken(),
            contentType: "application/json"
        )

        return Future<ProfileResponse, Error> { completion in
            AF.request(url, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let responseData = JSON(data)
                    let profileResponse = ProfileResponse(json: responseData)
                    completion(.success(profileResponse))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
