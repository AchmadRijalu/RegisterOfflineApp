//
//  GeneralButton.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 17/04/26.
//

import SwiftUI

enum ButtonType {
    case filled
    case outlined
    case tonal
    case destructive
    case text
}

enum ButtonTint {
    case primary
    case success
    case danger
}

struct GeneralButton: View {
    let title: String
    var type: ButtonType = .filled
    var tint: ButtonTint = .primary
    var isDisabled: Bool = false
    var isLoading: Bool = false
    var height: CGFloat = 50
    var cornerRadius: CGFloat = 10
    var titleFont: Font = .system(size: 16, weight: .semibold)
    var usesUppercasedTitle: Bool = false
    var leadingSystemImage: String? = nil
    var disabledOpacity: CGFloat = 0.55
    var borderWidth: CGFloat = 1

    /// When set, used for the title and leading icon; otherwise derived from `type` and `tint`.
    var foreground: Color? = nil
    /// When set, used for the outline; otherwise derived from `type` and `tint`.
    var stroke: Color? = nil
    /// When set, used for the button background; otherwise derived from `type` and `tint`.
    var fill: Color? = nil

    let action: () -> Void

    private var displayTitle: String {
        if type == .text { return title }
        return usesUppercasedTitle ? title.uppercased() : title
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .tint(type == .filled ? .white : resolvedForeground)
                }

                if let leadingSystemImage, !isLoading {
                    Image(systemName: leadingSystemImage)
                        .font(titleFont)
                }

                Text(displayTitle)
                    .font(titleFont)
            }
            .foregroundStyle(resolvedForeground)
            .frame(maxWidth: .infinity)
            .frame(height: height)
        }
        .disabled(isDisabled || isLoading)
        .background(resolvedFill)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(resolvedStroke, lineWidth: hasBorder ? borderWidth : 0)
        )
        .opacity((isDisabled || isLoading) ? disabledOpacity : 1)
    }

    private var tintColor: Color {
        switch tint {
        case .primary: return .brandSecondary
        case .success: return .green
        case .danger: return .red
        }
    }

    private var tonalFill: Color {
        switch tint {
        case .primary: return Color.brandSecondary.opacity(0.12)
        case .success: return Color.green.opacity(0.12)
        case .danger: return Color.red.opacity(0.12)
        }
    }

    private var resolvedFill: Color {
        if let fill { return fill }
        switch type {
        case .filled: return tintColor
        case .outlined, .text: return .clear
        case .tonal: return tonalFill
        case .destructive: return .clear
        }
    }

    private var resolvedForeground: Color {
        if let foreground { return foreground }
        switch type {
        case .filled: return .white
        case .outlined, .text: return tintColor
        case .tonal: return tintColor
        case .destructive: return .red
        }
    }

    private var resolvedStroke: Color {
        if let stroke { return stroke }
        switch type {
        case .outlined: return tintColor
        case .destructive: return .red
        default: return .clear
        }
    }

    private var hasBorder: Bool {
        type == .outlined || type == .destructive
    }
}
