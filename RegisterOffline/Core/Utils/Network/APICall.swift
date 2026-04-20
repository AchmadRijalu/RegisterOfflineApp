//
//  APICall.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import Foundation
import Alamofire

struct APICall {
    static let baseUrl = "https://api-test.partaiperindo.com/api/v1"

    static var headers: HTTPHeaders {
        ["x-api-key": ""]
    }

    static func makeHeaders(
        bearerToken: String? = nil,
        contentType: String? = nil
    ) -> HTTPHeaders {
        var requestHeaders = headers

        if let bearerToken, !bearerToken.isEmpty {
            requestHeaders.add(name: "Authorization", value: "Bearer \(bearerToken)")
        }

        if let contentType, !contentType.isEmpty {
            requestHeaders.add(name: "Content-Type", value: contentType)
        }

        return requestHeaders
    }
}

protocol Endpoint {
    var url: String {get}
}

enum Endpoints {
    enum Gets: Endpoint {
        case register
        case login
        case profile
        case member
        case getMember
        
        var url: String {
            switch self {
            case .register:
                return "\(APICall.baseUrl)/register"
            case .login:
                return "\(APICall.baseUrl)/login"
            case .profile:
                return "\(APICall.baseUrl)/profile"
            case .member:
                return "\(APICall.baseUrl)/member"
            case .getMember:
                return "\(APICall.baseUrl)/member"
            }
        }
    }
}
