//
//  RegisterOfflineApp.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 16/04/26.
//

import SwiftUI
import SwiftData
import netfox

@main
struct RegisterOfflineApp: App {
    @StateObject private var coordinator = Coordinator(injection: Injection())

    var body: some Scene {
        WindowGroup {
            CoordinatorView()
                .environmentObject(coordinator)
                .modelContainer(SwiftDataStack.shared.container)
                .onAppear {
                    NFX.sharedInstance().start()
                }
        }
    }
}
