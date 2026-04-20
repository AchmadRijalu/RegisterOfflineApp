//
//  LoginRemoteDataSource.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

protocol LoginRemoteDataSourceProtocol: AnyObject {
    func login(email: String, password: String) -> AnyPublisher<String, Error>
    func getToken() -> String?
    func logout()
}

final class LoginRemoteDataSource: NSObject {
    private let keychainRepository: CredentialRepositoryProtocol

    static func sharedInstance(_ keychainRepository: CredentialRepositoryProtocol) -> LoginRemoteDataSource {
        LoginRemoteDataSource(keychainRepository: keychainRepository)
    }

    private init(keychainRepository: CredentialRepositoryProtocol) {
        self.keychainRepository = keychainRepository
        super.init()
    }
}

extension LoginRemoteDataSource: LoginRemoteDataSourceProtocol {

    func login(email: String, password: String) -> AnyPublisher<String, Error> {
        let url = Endpoints.Gets.login.url
        let headers = APICall.makeHeaders(contentType: "application/json")
        let parameters = [
            "email": email,
            "password": password
        ]

        return Future<String, Error> { [weak self] completion in
            AF.request(url,
                       method: .post,
                       parameters: parameters,
                       encoding: JSONEncoding.default,
                       headers: headers)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let loginResponse = LoginResponse(json: json)
                    let token = loginResponse.token

                    if let token, !token.isEmpty {
                        self?.keychainRepository.saveToken(token)
                        completion(.success(token))
                        return
                    }
                    
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func getToken() -> String? {
        keychainRepository.getToken()
    }

    func logout() {
        keychainRepository.deleteToken()
    }
}


extension LoginRemoteDataSource {
    enum AuthError: LocalizedError {
        case server(String)

        var errorDescription: String? {
            switch self {
            case .server(let message): return message
            }
        }
    }
}
