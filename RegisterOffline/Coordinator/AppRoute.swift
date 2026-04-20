//
//  AppRoute.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

enum AppPages: Hashable {
    case splash
    case login
    case register
    case documents
    case profile
    case createDocument
    case camera
    case confirmPhoto
}

enum FullScreenCover: String, Identifiable {
    case none
    var id: String {
        self.rawValue
    }
}
