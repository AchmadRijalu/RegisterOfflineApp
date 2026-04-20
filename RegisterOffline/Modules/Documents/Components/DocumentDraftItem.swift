//
//  DocumentDraftView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct DocumentDraftItem: View {
    let index: Int
    let draft: MemberDraftModel
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onUpload: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 10) {
                Text("\(index)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.textSecondary)
                    .frame(width: 24, height: 24)
                    .background(Color(hex: "#F1F5F9"))
                    .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))

                if let data = draft.primaryImageData, let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 52, height: 32)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 6, style: .continuous))
                } else {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color(hex: "#E2E8F0"))
                        .frame(width: 52, height: 32)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.system(size: 12))
                                .foregroundColor(.textSecondary)
                        }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(draft.nik)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.textPrimary)

                    Text(draft.name.isEmpty ? "-" : draft.name)
                        .font(.system(size: 12))
                        .foregroundColor(.textSecondary)
                        .lineLimit(1)
                }
                Spacer()

                Text(draft.draftStatus.rawValue)
                    .font(.system(size: 11, weight: .semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(Color(hex: "#FEF3C7"))
                    .foregroundColor(Color(hex: "#92400E"))
                    .clipShape(Capsule())
            }
            .padding(12)

            Divider()

            HStack(spacing: 0) {
                Button(action: onEdit) {
                    Label("Edit", systemImage: "pencil")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.brandSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)

                Divider()

                Button(action: onDelete) {
                    Label("Delete", systemImage: "trash")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)

                Divider()

                Button(action: onUpload) {
                    Label("Upload", systemImage: "square.and.arrow.up")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.brandSecondary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
            }
        }
        .cardStyle(
            shape: .rounded,
            variant: .bordered,
            padding: 0,
            backgroundColor: .white,
            borderColor: Color(hex: "#E2E8F0"),
            borderWidth: 1
        )
    }
}
