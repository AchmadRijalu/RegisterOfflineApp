//
//  GeneralDropdownField.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftUI

struct GeneralDropdownField: View {
    let title: String
    let placeholder: String
    let options: [String]
    @Binding var selection: String

    private var isRequiredTitle: Bool {
        title.hasSuffix(" *")
    }

    private var cleanTitle: String {
        isRequiredTitle ? String(title.dropLast(2)) : title
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 0) {
                Text(cleanTitle)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)

                if isRequiredTitle {
                    Text(" *")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.red)
                }
            }

            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection = option
                    }
                }
            } label: {
                HStack(spacing: 10) {
                    Text(selection.isEmpty ? placeholder : selection)
                        .font(.body)
                        .foregroundStyle(selection.isEmpty ? .secondary : .primary)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
                .frame(height: 52)
                .padding(.horizontal, 14)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .buttonStyle(.plain)
        }
    }
}
