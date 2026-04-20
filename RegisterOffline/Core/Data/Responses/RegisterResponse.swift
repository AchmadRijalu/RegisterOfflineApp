//
//  RegisterResponse.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftyJSON

final class RegisterResponse {
    let message: String?

    init(json: JSON) {
        message = json["message"].string
    }
}
