//
//  LoginResponse.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftyJSON

class LoginResponse {
    var token: String?
    
    init(json: JSON) {
        token = json["token"].string
    }
}
