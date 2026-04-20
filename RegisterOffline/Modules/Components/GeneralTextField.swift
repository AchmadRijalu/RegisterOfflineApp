//
//  GeneralTextField.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

struct GeneralTextField: View {
    let title: String
    let placeholder: String
    @Binding var text: String

    var leadingSystemIcon: String? = nil
    var trailingSystemIcon: String? = nil
    var trailingIconAction: (() -> Void)? = nil
    var onFieldTap: (() -> Void)? = nil
    var isPassword: Bool = false
    var keyboardType: UIKeyboardType = .default
    var isEnabled: Bool = true
    var forgotPasswordTitle: String? = nil
    var forgotPasswordHandler: (() -> Void)? = nil

    @State private var isSecure: Bool = true

    private var isRequiredTitle: Bool {
        title.hasSuffix(" *")
    }

    private var cleanTitle: String {
        isRequiredTitle ? String(title.dropLast(2)) : title
    }

    private var useTappableField: Bool {
        onFieldTap != nil && isEnabled
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
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

                if let forgotPasswordTitle {
                    Spacer()
                    Button(action: { forgotPasswordHandler?() }) {
                        Text(forgotPasswordTitle)
                            .font(.subheadline)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(.blue)
                }
            }

            Group {
                if useTappableField {
                    Button(action: { onFieldTap?() }) {
                        tappableContent
                    }
                    .buttonStyle(.plain)
                } else {
                    editableContent
                }
            }
            .frame(height: 52)
            .padding(.horizontal, 14)
            .background(isEnabled ? Color.white : Color.gray.opacity(0.08))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .disabled(!isEnabled)
        }
    }

    private var editableContent: some View {
        HStack(spacing: 10) {
            if let leadingSystemIcon {
                Image(systemName: leadingSystemIcon)
                    .foregroundStyle(.secondary)
            }

            Group {
                if isPassword && isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(isPassword ? .default : keyboardType)
                }
            }
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .font(.body)

            if isPassword {
                Button(action: { isSecure.toggle() }) {
                    Image(systemName: isSecure ? "eye" : "eye.slash")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            } else if let trailingSystemIcon {
                Group {
                    if let trailingIconAction {
                        Button(action: trailingIconAction) {
                            Image(systemName: trailingSystemIcon)
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                    } else {
                        Image(systemName: trailingSystemIcon)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private var tappableContent: some View {
        HStack(spacing: 10) {
            if let leadingSystemIcon {
                Image(systemName: leadingSystemIcon)
                    .foregroundStyle(.secondary)
            }

            Text(text.isEmpty ? placeholder : text)
                .font(.body)
                .foregroundStyle(text.isEmpty ? .secondary : .primary)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let trailingSystemIcon {
                Image(systemName: trailingSystemIcon)
                    .foregroundStyle(.secondary)
            }
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var email = ""
        @State private var password = ""

        var body: some View {
            VStack(spacing: 16) {
                GeneralTextField(
                    title: "Email *",
                    placeholder: "Masukkan email",
                    text: $email,
                    leadingSystemIcon: "envelope"
                )

                GeneralTextField(
                    title: "Password *",
                    placeholder: "Masukkan password",
                    text: $password,
                    leadingSystemIcon: "lock",
                    isPassword: true,
                    forgotPasswordTitle: "Forgot password?",
                    forgotPasswordHandler: {}
                )
            }
            .padding()
        }
    }

    return PreviewWrapper()
}
