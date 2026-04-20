//
//  SwiftDataStack.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 21/04/26.
//

import SwiftData
import Foundation

@MainActor
final class SwiftDataStack {
    static let shared = SwiftDataStack()

    let container: ModelContainer

    private init() {
        do {
            container = try ModelContainer(for: MemberDraftEntity.self)
        } catch {
            fatalError("Failed to create SwiftData container: \(error.localizedDescription)")
        }
    }
}
