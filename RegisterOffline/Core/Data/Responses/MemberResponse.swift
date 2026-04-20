//
//  MemberResponse.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import Foundation
import SwiftyJSON

final class MemberResponse {
    let name: String?
    let nik: String?
    let phone: String?
    let ktpURL: String?
    let ktpURLSecondary: String?

    init(json: JSON) {
        name = MemberResponse.normalizedString(json["name"])
        nik = MemberResponse.normalizedString(json["nik"])
        phone = MemberResponse.normalizedString(json["phone"])
        ktpURL = MemberResponse.normalizedString(json["ktp_url"])
        ktpURLSecondary = MemberResponse.normalizedString(json["ktp_url_secondary"])
    }

    private static func normalizedString(_ json: JSON) -> String? {
        let value = json.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        return value.isEmpty ? nil : value
    }
}
