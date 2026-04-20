//
//  CardStyle.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 19/04/26.
//

import SwiftUI

struct CardStyle: ViewModifier {
    var shape: CardShape
    var cornerRadius: CGFloat
    var variant: CardVariant
    var padding: CGFloat
    var backgroundColor: Color
    var borderColor: Color
    var borderWidth: CGFloat

    enum CardShape {
        case rounded
        case capsule
        case rectangular
    }

    enum CardVariant {
        case bordered
        case elevated
        case plain
    }

    func body(content: Content) -> some View {
        content
            .padding(padding)
            .background {
                switch shape {
                case .rounded:
                    chrome(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
                case .capsule:
                    chrome(Capsule())
                case .rectangular:
                    chrome(Rectangle())
                }
            }
    }

    @ViewBuilder
    private func chrome<S: Shape>(_ shape: S) -> some View {
        shape
            .fill(backgroundColor)
            .overlay {
                if variant == .bordered {
                    shape.stroke(borderColor, lineWidth: borderWidth)
                }
            }
            .shadow(
                color: variant == .elevated ? .black.opacity(0.08) : .clear,
                radius: 8,
                x: 0,
                y: 2
            )
    }
}

extension View {
    func cardStyle(
        shape: CardStyle.CardShape = .rounded,
        cornerRadius: CGFloat = 12,
        variant: CardStyle.CardVariant = .bordered,
        padding: CGFloat = 16,
        backgroundColor: Color = .white,
        borderColor: Color = Color(hex: "#C7D2FE"),
        borderWidth: CGFloat = 1
    ) -> some View {
        modifier(
            CardStyle(
                shape: shape,
                cornerRadius: cornerRadius,
                variant: variant,
                padding: padding,
                backgroundColor: backgroundColor,
                borderColor: borderColor,
                borderWidth: borderWidth
            )
        )
    }
}
