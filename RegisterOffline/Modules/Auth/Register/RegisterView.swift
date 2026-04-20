//
//  RegisterView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

struct RegisterView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var viewModel: RegisterViewModel

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

            ScrollView {
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

                    Text("Daftar Akun Verifikator")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.textPrimary)
                        .padding(.top, 36)

                    Text("Isi data berikut untuk membuat akun baru")
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

                    GeneralTextField(
                        title: "Full Name *",
                        placeholder: "Masukkan nama lengkap",
                        text: $viewModel.fullName
                    )
                    .padding(.top, 20)

                    GeneralTextField(
                        title: "Phone",
                        placeholder: "Masukkan nomor telepon (opsional)",
                        text: $viewModel.phone,
                        keyboardType: .phonePad
                    )
                    .padding(.top, 20)

                    GeneralButton(
                        title: "Register",
                        type: .filled,
                        tint: .primary,
                        isDisabled: !viewModel.isRegisterButtonEnabled,
                        isLoading: viewModel.isLoading,
                        height: 56,
                        titleFont: .system(size: 14, weight: .semibold),
                        usesUppercasedTitle: true,
                        foreground: viewModel.isRegisterButtonEnabled ? nil : Color(hex: "#C4C8CF"),
                        action: {
                            viewModel.register()
                        }
                    )
                    .grayscale(viewModel.isRegisterButtonEnabled ? 0 : 1)
                    .padding(.top, 24)

                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .padding(.top, 10)
                    }

                    if let successMessage = viewModel.successMessage {
                        Text(successMessage)
                            .font(.footnote)
                            .foregroundColor(.green)
                            .padding(.top, 10)
                    }

                    Spacer(minLength: 24)
                }
                .padding(.horizontal, 24)
            }
        }
        .navigationTitle("Register")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.didRegisterSuccess) { _, success in
            guard success else { return }
            coordinator.pop()
        }
    }
}

#Preview {
    NavigationStack {
        RegisterView(
            viewModel: RegisterViewModel(
                repository: RegisterRepository.sharedInstance(RegisterRemoteDataSource.sharedInstance)
            )
        )
        .environmentObject(Coordinator(injection: Injection()))
    }
}
