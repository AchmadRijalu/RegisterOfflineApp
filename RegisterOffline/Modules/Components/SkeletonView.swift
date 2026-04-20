//
//  SkeletonView.swift
//  RegisterOffline
//
//  Created by Achmad Rijalu on 20/04/26.
//

import SwiftUI

struct SkeletonView: View {
    var width: CGFloat? = nil
    var height: CGFloat = 14
    var cornerRadius: CGFloat = 8
    var baseColor: Color = Color(hex: "#E2E8F0")
    var highlightColor: Color = Color.white.opacity(0.75)

    @State private var shimmerOffset: CGFloat = -1

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(baseColor)
            .frame(width: width, height: height)
            .overlay {
                GeometryReader { proxy in
                    let width = max(proxy.size.width, 1)

                    LinearGradient(
                        colors: [
                            .clear,
                            highlightColor,
                            .clear
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .rotationEffect(.degrees(20))
                    .offset(x: shimmerOffset * width * 2)
                }
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            }
            .onAppear {
                shimmerOffset = -1
                withAnimation(.linear(duration: 1.15).repeatForever(autoreverses: false)) {
                    shimmerOffset = 1.2
                }
            }
            .onDisappear {
                shimmerOffset = -1
            }
    }
}
