//
//  Route.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI
import Combine
import UIKit

@MainActor
class Coordinator: ObservableObject {
    enum CaptureSlot {
        case primary
        case secondary
    }

    @Published var path: NavigationPath = NavigationPath()
    @Published var fullScreenCover: FullScreenCover?
    @Published var rootPage: AppPages = .splash
    @Published var currentCaptureSlot: CaptureSlot = .primary
    @Published var capturedKtpImage: UIImage?
    @Published var primaryKtpImage: UIImage?
    @Published var secondaryKtpImage: UIImage?
    @Published var hasPrimaryKtpPhoto = false
    @Published var hasSecondaryKtpPhoto = false
    let injection: Injection

    init(injection: Injection) {
        self.injection = injection
    }

    func replaceRoot(with page: AppPages) {
        rootPage = page
        popToRoot()
    }

    func logoutSession() {
        injection.provideLogin().logout()
        replaceRoot(with: .login)
    }

    func push(page: AppPages) {
        if page == .createDocument {
            resetCreateDocumentCaptureState()
        }
        path.append(page)
    }
    
    func pop() {
        path.removeLast()
    }

    func pop(count: Int) {
        guard count > 0 else { return }
        let safeCount = min(count, path.count)
        guard safeCount > 0 else { return }
        path.removeLast(safeCount)
    }
    
    func popToRoot() {
        path.removeLast(path.count)
    }
    
    func presentFullScreenCover(_ cover: FullScreenCover) {
        self.fullScreenCover = cover
    }
    
    func dismissCover() {
        self.fullScreenCover = nil
    }

    func resetCreateDocumentCaptureState() {
        currentCaptureSlot = .primary
        capturedKtpImage = nil
        primaryKtpImage = nil
        secondaryKtpImage = nil
        hasPrimaryKtpPhoto = false
        hasSecondaryKtpPhoto = false
    }
    
    @ViewBuilder
    func build(page: AppPages) -> some View {
        switch page {
        case .splash:
            EmptyView()
        case .login:
            let loginViewModel = injection.makeLoginViewModel()
            LoginView(viewModel: loginViewModel)
        case .register:
            let registerViewModel = injection.makeRegisterViewModel()
            RegisterView(viewModel: registerViewModel)
        case .documents:
            let documentViewModel = injection.makeDocumentViewModel()
            DocumentsView(viewModel: documentViewModel)
        case .profile:
            let profileViewModel = injection.makeProfileViewModel()
            ProfileView(viewModel: profileViewModel)
        case .createDocument:
            let createDocumentViewModel = injection.makeCreateDocumentViewModel()
            CreateDocumentView(viewModel: createDocumentViewModel)
        case .camera:
            CameraView()
        case .confirmPhoto:
            ConfirmationCardView()
        }
    }
    
    @ViewBuilder
    func buildCover(cover: FullScreenCover) -> some View {
        switch cover {
        case .none:
            EmptyView()
        }
    }
}
