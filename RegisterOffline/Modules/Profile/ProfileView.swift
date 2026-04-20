//
//  ProfileView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var coordinator: Coordinator
    @ObservedObject var viewModel: ProfileViewModel
    @State private var isLogoutConfirmationPresented = false

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                Group {
                    if viewModel.isLoading {
                        ProfileHeaderSkeletonView()
                    } else {
                        VStack(spacing: 10) {
                            Image(.imageProfile)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 120, height: 120)
                                .clipShape(.circle)

                            Text(viewModel.fullName)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundStyle(Color.brandSecondary)

                            Text(viewModel.address)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.black)
                                .multilineTextAlignment(.center)

                            Text(viewModel.email)
                                .font(.system(size: 14))
                                .foregroundStyle(Color.black)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

                VStack(spacing: 0) {
                    ProfileMenuRow(systemImage: "ellipsis", title: "Ganti Password", action: {})
                    Divider()
                        .padding(.leading, 54)
                    ProfileMenuRow(systemImage: "questionmark.circle", title: "Bantuan", action: {})
                }
                .cardStyle(shape: .rounded, variant: .plain, padding: 0, borderColor: Color(hex: "#E2E8F0"), borderWidth: 0)

                ProfileMenuRow(
                    systemImage: "rectangle.portrait.and.arrow.right",
                    title: "Keluar",
                    isDestructive: true,
                    action: { isLogoutConfirmationPresented = true }
                )
                .cardStyle(shape: .rounded, variant: .plain, padding: 0, borderColor: Color(hex: "#E2E8F0"), borderWidth: 0)

                Spacer()
                Text("v1.0.1")
                    .font(.system(size: 13))
                    .foregroundStyle(Color.textSecondary.opacity(0.7))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 8)
                    .padding(.bottom, 24)
            }
            .padding(.horizontal, 16)
        }
        .background(Color.backgroundPrimary)
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadProfileIfNeeded()
        }
        .bottomSheet(isPresented: $isLogoutConfirmationPresented) {
            LogoutConfirmationSheet(
                onConfirm: {
                    isLogoutConfirmationPresented = false
                    coordinator.logoutSession()
                },
                onCancel: { isLogoutConfirmationPresented = false }
            )
        }
    }
}

private struct ProfileHeaderSkeletonView: View {
    var body: some View {
        VStack(spacing: 12) {
            SkeletonView(width: 120, height: 120, cornerRadius: 60)

            SkeletonView(width: 200, height: 24, cornerRadius: 10)

            SkeletonView(height: 14, cornerRadius: 8)
                .frame(maxWidth: 270)

            SkeletonView(width: 220, height: 14, cornerRadius: 8)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(viewModel: ProfileViewModel(
            repository: ProfileRepository.sharedInstance(
                ProfileRemoteDataSource.sharedInstance(CredentialRepository())
            )
        ))
            .environmentObject(Coordinator(injection: Injection()))
    }
}
