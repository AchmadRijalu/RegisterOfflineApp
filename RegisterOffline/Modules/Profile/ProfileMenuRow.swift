//
//  ProfileMenuRow.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct ProfileMenuRow: View {
    let systemImage: String
    let title: String
    var isDestructive: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(isDestructive ? Color.red.opacity(0.9) : Color.textSecondary)
                    .frame(width: 26, alignment: .center)

                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(isDestructive ? Color.red : Color.textPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textSecondary.opacity(0.45))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    VStack(spacing: 0) {
        ProfileMenuRow(systemImage: "key.fill", title: "Ganti Password", action: {})
        Divider().padding(.leading, 54)
        ProfileMenuRow(systemImage: "questionmark.circle", title: "Bantuan", action: {})
    }
    .cardStyle(shape: .rounded, variant: .bordered, padding: 0, borderColor: Color(hex: "#E2E8F0"), borderWidth: 1)
    .padding()
    .background(Color.backgroundPrimary)
}
