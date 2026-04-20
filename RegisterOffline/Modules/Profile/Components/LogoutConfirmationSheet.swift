//
//  LogoutConfirmationSheet.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct LogoutConfirmationSheet: View {
    let onConfirm: () -> Void
    let onCancel: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 12) {
                Button(action: onCancel) {
                    Image(systemName: "xmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)
                }
                .buttonStyle(.plain)

                Text("Keluar")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(Color.textPrimary)

                Spacer(minLength: 0)
            }
            .padding(.bottom, 20)

            Image(.imageConfirmation)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 4)

            Text("Apakah kamu yakin ingin keluar?")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(Color.textPrimary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)

            Text("Data yang ada di draft-mu mungkin akan hilang. Kami sarankan untuk upload terlebih dahulu.")
                .font(.system(size: 14))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)

            VStack(spacing: 12) {
                GeneralButton(
                    title: "Ya, keluar",
                    type: .filled,
                    tint: .primary,
                    usesUppercasedTitle: false,
                    action: onConfirm
                )

                GeneralButton(
                    title: "Batal",
                    type: .outlined,
                    tint: .primary,
                    usesUppercasedTitle: false,
                    action: onCancel
                )
            }
            .padding(.top, 24)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
    }
}

#Preview {
    LogoutConfirmationSheet(onConfirm: {}, onCancel: {})
        .padding()
        .background(Color.backgroundPrimary)
}
