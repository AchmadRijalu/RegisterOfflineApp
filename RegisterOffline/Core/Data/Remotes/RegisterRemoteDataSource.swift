//
//  RegisterRemoteDataSource.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Alamofire
import Combine
import SwiftyJSON

protocol RegisterRemoteDataSourceProtocol: AnyObject {
    func register(email: String, password: String, fullName: String, phone: String?) -> AnyPublisher<String, Error>
}

final class RegisterRemoteDataSource: NSObject {
    static let sharedInstance = RegisterRemoteDataSource()
}

extension RegisterRemoteDataSource: RegisterRemoteDataSourceProtocol {
    func register(email: String, password: String, fullName: String, phone: String?) -> AnyPublisher<String, Error> {
        let url = Endpoints.Gets.register.url
        let headers = APICall.makeHeaders(contentType: "application/json")

        var parameters: [String: Any] = [
            "email": email,
            "password": password,
            "full_name": fullName
        ]

        let trimmedPhone = phone?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        if !trimmedPhone.isEmpty {
            parameters["phone"] = trimmedPhone
        }

        return Future<String, Error> { completion in
            AF.request(
                url,
                method: .post,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let registerResponse = RegisterResponse(json: json)

                    if let message = registerResponse.message, !message.isEmpty {
                        completion(.success(message))
                        return
                    }


                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

extension RegisterRemoteDataSource {
    enum RegisterError: LocalizedError {
        case server(String)

        var errorDescription: String? {
            switch self {
            case .server(let message):
                return message
            }
        }
    }
}
