//
//  UploadMemberResponse.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftyJSON

final class UploadMemberResponse {
    let message: String?

    init(json: JSON) {
        message = json["message"].string
    }
}
