//
//  ProfileResponse.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftyJSON
import Foundation

final class ProfileResponse {
    let id: String?
    let fullName: String?
    let email: String?
    let address: String?

    init(json: JSON) {
        let source = json["data"].exists() ? json["data"] : json
        id = ProfileResponse.normalizedString(source["id"])
        fullName = ProfileResponse.normalizedString(source["full_name"])
        email = ProfileResponse.normalizedString(source["email"])
        address = ProfileResponse.normalizedString(source["address"])
    }

    private static func normalizedString(_ json: JSON) -> String? {
        let value = json.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
