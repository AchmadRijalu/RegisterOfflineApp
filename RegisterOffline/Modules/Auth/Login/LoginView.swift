//
//  LoginView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var viewModel: LoginViewModel

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "#EDE9FE"),
                    Color.white,
                    Color.white
                ],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 10) {
                    Image(.imageRegisteroffline)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundColor(.brandSecondary)

                    Text("Register Offline")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textPrimary)
                }
                .padding(.top, 24)

                Text("Masuk ke Akun Verifikator")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.textPrimary)
                    .padding(.top, 36)

                Text("Masukkan email dan password untuk masuk")
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.textSecondary)
                    .padding(.top, 8)

                GeneralTextField(
                    title: "Email *",
                    placeholder: "Masukkan email di sini",
                    text: $viewModel.email,
                    keyboardType: .emailAddress
                )
                .padding(.top, 32)

                GeneralTextField(
                    title: "Password *",
                    placeholder: "Masukkan password",
                    text: $viewModel.password,
                    isPassword: true
                )
                .padding(.top, 20)

                GeneralButton(
                    title: "Login",
                    type: .filled,
                    tint: .primary,
                    isDisabled: !viewModel.isLoginButtonEnabled,
                    isLoading: viewModel.isLoading,
                    height: 56,
                    titleFont: .system(size: 14, weight: .semibold),
                    usesUppercasedTitle: true,
                    foreground: viewModel.isLoginButtonEnabled ? nil : Color(hex: "#C4C8CF"),
                    action: {
                        viewModel.login()
                    }
                )
                .grayscale(viewModel.isLoginButtonEnabled ? 0 : 1)
                .padding(.top, 24)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.footnote)
                        .foregroundColor(.red)
                        .padding(.top, 8)
                }

                Spacer()

                HStack(spacing: 6) {
                    Text("Belum punya akun?")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundColor(.textPrimary)

                    Button("Klik Bantuan") {
                        coordinator.push(page: .register)
                    }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.brandSecondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 24)
        }
        .onChange(of: viewModel.didLoginSuccess) { _, success in
            guard success else { return }
            print(viewModel.getSavedToken() ?? "token")
            coordinator.replaceRoot(with: .documents)
        }
    }
}

#Preview {
    LoginView(viewModel: LoginViewModel(repository: LoginRepository.sharedInstance(
        LoginRemoteDataSource.sharedInstance(CredentialRepository())
    )))
    .environmentObject(Coordinator(injection: Injection()))
}
