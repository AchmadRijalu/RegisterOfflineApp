//
//  CoordinatorView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

struct CoordinatorView: View {
    @EnvironmentObject private var coordinator: Coordinator

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                switch coordinator.rootPage {
                case .splash:
                    SplashScreen {
                        let token = coordinator.injection.makeCredentialRepository().getToken()
                        withAnimation(.easeInOut(duration: 0.1)) {
                            if let token, !token.isEmpty {
                                coordinator.replaceRoot(with: .documents)
                            } else {
                                coordinator.replaceRoot(with: .login)
                            }
                        }
                    }
                case .login:
                    coordinator.build(page: .login)
                case .register, .documents, .profile, .createDocument, .camera, .confirmPhoto:
                    coordinator.build(page: coordinator.rootPage)
                }
            }
            .navigationBarBackButtonHidden(true)
                .navigationDestination(for: AppPages.self) { page in
                    coordinator.build(page: page)
                        .navigationBarBackButtonHidden(false)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { item in}
        }
    }
}
